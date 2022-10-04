extends CanvasLayer

enum _interaction_states {NONE, MOVE}
var _interaction_state : int = _interaction_states.NONE setget _set_interaction_state
func _set_interaction_state(value : int) -> void:
	Dprint.info("Changing state to: %s" % _interaction_states.keys()[value], "INTERACTION_STATE")
	# always update state since will only be called if mouse cell has changed
	var from_state := _interaction_state
	_interaction_state = value
	_update_interaction_state(from_state, value)


var prev_mouse_cell : Vector2
var mouse_cell : Vector2 setget set_mouse_cell
func set_mouse_cell(value : Vector2) -> void:
	prev_mouse_cell = mouse_cell
	mouse_cell = value

var mouse_entity setget set_mouse_entity
func set_mouse_entity(value) -> void:
	if value == mouse_entity:
		return
	mouse_entity = value


#onready var tileSelector := $"%TileSelector"
#onready var viewportTooltip := $"%ViewportTooltip"

var selected_path_positions : PoolVector2Array

onready var navTarget := $"%NavTarget"
onready var navLine := $"%NavLine"


func _ready() -> void:
	Events.connect("entity_selected", self, "_on_Events_entity_selected")
	

func _input(event: InputEvent) -> void:	
	if Game.selected_entity == null:
		return
	if !is_instance_valid(Game.selected_entity):
		return
	if !Game.selected_entity.can_move:
		return
	
	if Utils.event_is_left_click(event):
		_mouse_press(event)
	elif Utils.event_is_right_click(event):
		_deselect_entity()
	elif Utils.event_is_mouse_move(event):
		_mouse_move(event)
		

func _mouse_press(event: InputEvent) -> void:	
	match _interaction_state:
		_interaction_states.MOVE:
			Game.selected_entity.move_along_path(selected_path_positions)
	self._interaction_state = _interaction_states.NONE
	_deselect_entity()

func _mouse_move(event: InputEvent) -> void:
	self.mouse_cell = _get_mouse_cell()	
	
	if mouse_cell == prev_mouse_cell:
		# no update needed if cell unchanged
		return
	
#	print("mouse_move")	
	if Game.selected_entity.can_move:
#		print("entity can move")
		_check_for_movement_path()
	


	

# INTERACTION STATES
func _check_for_movement_path() -> void:
	selected_path_positions = Game.navmap.get_nav_path_positions(Game.selected_entity.cell, mouse_cell)
	if selected_path_positions == Game.INVALID_PATH:
		navLine.hide()
		navTarget.hide()
		self._interaction_state = _interaction_states.NONE
		return
		
	self._interaction_state = _interaction_states.MOVE


func _update_interaction_state(from_state : int, to_state : int) -> void:
	match from_state:
		_interaction_states.MOVE:
			navLine.hide()
			navTarget.hide()
	
	
	match to_state:
		_interaction_states.MOVE:
			_remove_entity_connections(Game.selected_entity)
			navLine.points = selected_path_positions
			navTarget.global_position = Game.navmap.get_position_at_cell(mouse_cell)
			navLine.show()
			navTarget.show()



# FUNCTIONS
func _get_mouse_cell() -> Vector2:
	return Game.navmap.get_cell_at_position(Game.navmap.get_global_mouse_position())

func _deselect_entity() -> void:
	Events.emit_signal("entity_selected", null)
	self._interaction_state = _interaction_states.NONE


func _remove_entity_connections(entity : Entity) -> void:
	if !Game.selected_entity:
		return
		
	if Game.selected_entity.is_connected("movement_completed", self, "_on_Entity_movement_completed"):
		Game.selected_entity.disconnect("movement_completed", self, "_on_Entity_movement_completed")


# SIGNALS
func _on_Events_entity_selected(entity) -> void:
	if entity == Game.selected_entity:
		return
	
	_remove_entity_connections(Game.selected_entity)
	Game.selected_entity = entity


