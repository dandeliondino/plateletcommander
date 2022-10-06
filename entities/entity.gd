class_name Entity
extends Node2D

signal movement_completed
signal became_clotted

var focus_material := preload("res://assets/materials/hover_outline.tres")
var pressed_material := preload("res://assets/materials/pressed_outline.tres")


export(String) var ink_path := ""
export(bool) var can_hover := false setget set_can_hover
func set_can_hover(value : bool) -> void:
	if value == can_hover:
		return
	can_hover = value

export(bool) var can_select := false setget set_can_select
func set_can_select(value : bool) -> void:
	if value == can_select:
		return
	can_select = value
	if value == true:
		Events.connect("entity_selected", self, "_on_Events_entity_selected")
	else:
		Events.disconnect("entity_selected", self, "_on_Events_entity_selected")

export(bool) var can_move := false
export(bool) var can_connect := false
export(bool) var can_pick := false
export(Game.POWERUP) var pick_data

var group : String setget set_group
func set_group(value : String) -> void:
	if group:
		self.remove_from_group(group)
	group = value
	self.add_to_group(value)


export(float) var speed := 0.1

export(bool) var _can_connect_left := false
export(bool) var _can_connect_up_left := false
export(bool) var _can_connect_up := false
export(bool) var _can_connect_up_right := false
export(bool) var _can_connect_right := false
export(bool) var _can_connect_down_right := false
export(bool) var _can_connect_down := false
export(bool) var _can_connect_down_left := false

enum connection_strengths {NONE, PLUG, FIBRIN, XLINK}
onready var _connections := {
	Game.DIRECTION.LEFT: {
		"can_connect": _can_connect_left,
		"control": null,
		"entity": null,
		"strength": connection_strengths.NONE,
	},
	Game.DIRECTION.UP_LEFT: {
		"can_connect": _can_connect_up_left,
		"control": null,
		"entity": null,
		"strength": connection_strengths.NONE,
	},
	Game.DIRECTION.UP: {
		"can_connect": _can_connect_up,
		"control": null,
		"entity": null,
		"strength": connection_strengths.NONE,
	},
	Game.DIRECTION.UP_RIGHT: {
		"can_connect": _can_connect_up_right,
		"control": null,
		"entity": null,
		"strength": connection_strengths.NONE,
	},
	Game.DIRECTION.RIGHT: {
		"can_connect": _can_connect_right,
		"control": null,
		"entity": null,
		"strength": connection_strengths.NONE,
	},
	Game.DIRECTION.DOWN_RIGHT: {
		"can_connect": _can_connect_down_right,
		"control": null,
		"entity": null,
		"strength": connection_strengths.NONE,
	},
	Game.DIRECTION.DOWN: {
		"can_connect": _can_connect_down,
		"control": null,
		"entity": null,
		"strength": connection_strengths.NONE,
	},
	Game.DIRECTION.DOWN_LEFT: {
		"can_connect": _can_connect_down_left,
		"control": null,
		"entity": null,
		"strength": connection_strengths.NONE,
	},
}





# STATE VARIABLES
var focused := false setget set_focused
func set_focused(value : bool) -> void:
	if value == focused:
		return
	focused = value
	if value == true:
		_set_sprite_outline_focused()
		show_tooltip()
		Events.emit_signal("entity_focus_gained", self)
		_on_focus_gained()
	else:
		_reset_sprite_outline()
		Game.tooltip.hide_immediately(self)
		Events.emit_signal("entity_focus_lost", self)
		_on_focus_lost()


var selected := false setget set_selected
func set_selected(value : bool) -> void:
	if value == selected:
		return
	selected = value
	if value == true:
		_set_sprite_outline_pressed()
		_on_selected()
	else:
		_reset_sprite_outline()
		_on_deselected()


var cell : Vector2 setget set_cell
func set_cell(value : Vector2) -> void:
	if value == cell:
		return
	var previous_cell = cell
	cell = value
	Events.emit_signal("entity_cell_changed", self, previous_cell, cell)


var clotted := false setget set_clotted
func set_clotted(value : bool) -> void:
	if value == clotted:
		return
	clotted = value
	if value == true:
		can_move = false
		can_select = false
		print("%s clotted" % name)
		emit_signal("became_clotted")

# READY VARIABLES
var tween : SceneTreeTween
onready var sprite := $"%Sprite"
onready var control := $"%Control"


func _ready() -> void:
	add_to_group(Game.ENTITY_GROUP)
	control.connect("mouse_entered", self, "_on_mouse_entered")
	control.connect("mouse_exited", self, "_on_mouse_exited")
	control.connect("gui_input", self, "_on_input_event")
	control.rect_size = Vector2(32, 32)
	control.rect_position = Vector2(-16, -16)
	
	if !Game.started:
		yield(Events, "level_loaded")
	elif Game.state != Game.states.WORLD:
		yield(Events, "game_state_changed")
	else:
		yield(get_tree(),"idle_frame")
	
	if cell:
		global_position = Game.navmap.get_position_at_cell(cell)
	else:
		update_cell()


func _on_focus_gained() -> void:
	# override this function
	pass

func _on_focus_lost() -> void:
	# override this function
	pass

func _on_selected() -> void:
	# override this function
	pass

func _on_deselected() -> void:
	# override this function
	pass

func _on_connection_made(entity : Entity, dir : int) -> void:
	# override this function
	pass



# Public functions
func can_interact() -> bool:
	# override this function
	return false


func make_connection_to(entity : Entity) -> bool:
	Events.emit_signal("entity_selected", null)
	if !can_connect_to(entity):
		Dprint.warning("Warning: Unable to make connection")
		return false
	
	if !entity.make_return_connection(self):
		return false
	
	_connect_to(entity)
	Events.emit_signal("connection_made")
	return true
	

func make_return_connection(entity : Entity) -> bool:
	if !can_connect_to(entity):
		Dprint.warning("Warning: Unable to return connection")
		return false
	
	_connect_to(entity)
	return true


func _connect_to(entity : Entity) -> void:
	var dir = get_direction_to_neighbor(entity)
	_connections[dir].entity = entity
	if _connections[dir].control:
		_connections[dir].control.show_as_connected()
	self.clotted = true
	_on_connection_made(entity, dir)
	


func can_connect_to(entity : Entity) -> bool:
#	Dprint.info("Testing if %s can connect to %s" % [self.name, entity.name])
	
	if !can_connect:
		Dprint.info("!can_connect", "NEIGHBOR")
		return false
	
	var dir = get_direction_to_neighbor(entity)
	Dprint.info("get_direction_to_neighbor(entity)=%s" % Game.DIRECTION.keys()[dir], "NEIGHBOR")
	if dir == Game.INVALID_NEIGHBOR:
		Dprint.info("dir == Game.INVALID_NEIGHBOR", "NEIGHBOR")
		return false
		
	return is_connection_available(dir)


func is_connection_available(dir : int) -> bool:
	if !_connections[dir].can_connect:
		Dprint.info("!_connections[dir].can_connect", "NEIGHBOR")
		return false
	
	if _connections[dir].entity:
		Dprint.info("_connections[dir].entity has an entity", "NEIGHBOR")
		return false
	
	return true


# ---------------------
# ACTIONS
# ---------------------

func pick() -> void:
	print("pick")
	assert(pick_data != null)
	Events.emit_signal("powerup_added", pick_data)
	remove_from_map()

func interact() -> void:
	# override this function
	pass

func apply_powerup(id : int) -> void:
	# override this function
	pass

func select() -> void:
	Events.emit_signal("entity_selected", self)



func update_cell() -> void:
	self.cell = Game.navmap.get_cell_at_node(self)

func remove_from_map() -> void:
	hide()
	self.cell = Game.INVALID_CELL
	queue_free()


func replace_with(packed_scene) -> void:
	var new_entity = packed_scene.instance()
	new_entity.global_position = global_position
	Game.entity_container.add_child(new_entity)
	remove_from_map()



func move_to_cell(target_cell : Vector2) -> void:
	Dprint.info("%s - move_to_cell(%s)" % [name, target_cell], "ENTITY_MOVEMENT")
	self.cell = target_cell # do this before moving, to release current cell and reserve target cell
	var pos = Game.navmap.get_position_at_cell(target_cell)
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "global_position", pos, Game.settings.passive_movement_speed)
	tween.tween_callback(self, "emit_signal", ["movement_completed"])


func set_position_to_current_cell() -> void:
	Dprint.info("%s - set_position_to_current_cell()" % [name], "ENTITY_MOVEMENT")
	move_to_cell_immediately(cell)

func move_to_cell_immediately(target_cell : Vector2) -> void:
	Dprint.info("%s - move_to_cell_immediately(%s)" % [name, target_cell], "ENTITY_MOVEMENT")
	if tween:
		tween.kill()
	self.cell = target_cell
	print("navmap pos: %s" % Game.navmap.get_position_at_cell(target_cell))
	global_position = Game.navmap.get_position_at_cell(target_cell)


func move_along_path(nav_path_positions : PoolVector2Array) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	for pos in nav_path_positions:
		tween.tween_property(self, "global_position", pos, speed)
		tween.tween_callback(self, "update_cell")
	tween.tween_callback(self, "emit_signal", ["movement_completed"])


func show_tooltip() -> void:
	if !ink_path:
		return
	var tooltip_text = Game.ink_manager.get_text(ink_path + ".tooltip")
	Game.tooltip.show_tooltip(self, tooltip_text, ink_path)


func is_neighbor(to_entity : Entity) -> bool:
	return Game.navmap.is_cell_next_to(cell, to_entity.cell)

func get_direction_to_neighbor(to_entity : Entity) -> int:
	if self == to_entity:
		Dprint.warning("Testing direction to self", "NEIGHBOR")
	
	var neighbor_direction = Game.navmap.get_neighbor_direction(cell, to_entity.cell)
	if neighbor_direction == Game.INVALID_NEIGHBOR:
		return Game.INVALID_NEIGHBOR
	Dprint.info("Direction from %s to %s = %s" % [self, to_entity, Game.DIRECTION.keys()[neighbor_direction]], "NEIGHBOR")
	return neighbor_direction


# Private functions
func _set_sprite_outline_focused() -> void:
	sprite.material = focus_material

func _set_sprite_outline_pressed() -> void:
	sprite.material = pressed_material

func _reset_sprite_outline() -> void:
	sprite.material = null




func _on_mouse_entered() -> void:
	if can_hover:
		self.focused = true

	
func _on_mouse_exited() -> void:
	if can_hover:
		self.focused = false


func _on_input_event(event: InputEvent) -> void:
	if Utils.event_is_right_click(event):
		if ink_path:
			Events.emit_signal("more_info_panel_requested", ink_path)

	elif Utils.event_is_left_click(event):
#		print("left click")
		if can_select && can_move:
			if self.selected:
				Events.emit_signal("entity_selected", null)
			else:
				select()
		if can_pick:
#			print("can pick")
			pick()

func _on_Events_entity_selected(entity) -> void:
	self.selected = (entity == self)


func _on_VisibilityNotifier2D_screen_exited() -> void:
	Dprint.info("%s - screen exited, queue_free()" % name, "ENTITY_MOVEMENT")
	queue_free()
	
