extends Node2D

export(Game.ENTITY) var entity_id : int
export(String, FILE) var entity_to_secrete_path : String
export(float) var min_time := 3.0
export(float) var max_time := 20.0
export(bool) var active := true

export(bool) var can_spawn_left := true
export(bool) var can_spawn_up_left := true
export(bool) var can_spawn_up := true
export(bool) var can_spawn_up_right := true
export(bool) var can_spawn_right := true
export(bool) var can_spawn_down_right := true
export(bool) var can_spawn_down := true
export(bool) var can_spawn_down_left := true
export(bool) var can_spawn_in_place := false


var entity_container : Node2D
var spawn_directions := []

onready var entity_to_secrete := load(entity_to_secrete_path)
onready var timer := Timer.new()
onready var rng = RandomNumberGenerator.new()


func _ready() -> void:
	rng.randomize()
	_setup_timer()
	_setup_spawn_directions()
	
	if !Game.level_loaded:
		yield(Events, "level_loaded")
	entity_container = Game.level.get_entity_container(entity_id)
	
	if active:
		_start_timer()


func _setup_spawn_directions() -> void:
	if can_spawn_left:
		spawn_directions.append(Game.DIRECTION.LEFT)
	if can_spawn_up_left:
		spawn_directions.append(Game.DIRECTION.UP_LEFT)
	if can_spawn_up:
		spawn_directions.append(Game.DIRECTION.UP)
	if can_spawn_up_right:
		spawn_directions.append(Game.DIRECTION.UP_RIGHT)
	if can_spawn_right:
		spawn_directions.append(Game.DIRECTION.RIGHT)
	if can_spawn_down_right:
		spawn_directions.append(Game.DIRECTION.DOWN_RIGHT)
	if can_spawn_down:
		spawn_directions.append(Game.DIRECTION.DOWN)
	if can_spawn_down_left:
		spawn_directions.append(Game.DIRECTION.DOWN_LEFT)



func secrete_entity() -> void:
	var node_count = get_tree().get_nodes_in_group(Game.ENTITY.keys()[entity_id]).size()
	if node_count >= Game.level.entity_spawns[entity_id].max:
		Dprint.info("Too many entities of type already on map")
		return
	
	var target_cell = _get_cell()
	if target_cell == Game.INVALID_CELL:
		Dprint.info("No valid cells available to spawn at", "ENTITY_MOVEMENT")
		return
	
	var secreted_entity : Entity = entity_to_secrete.instance()
	secreted_entity.cell = target_cell
	
	entity_container.add_child(secreted_entity)
	

func activate() -> void:
	active = true
	_start_timer()


func _get_current_cell() -> Vector2:
	return Game.navmap.get_cell_at_node(self)

func _get_cell() -> Vector2:
	var possible_cells := []
	var current_cell = _get_current_cell() # do here because entity might be moving
	
	for dir in spawn_directions:
		var target_cell = Game.navmap.get_neighbor_cell(current_cell, dir)
		if Game.navmap.is_cell_navigable(target_cell):
			possible_cells.append(target_cell)
	
	if can_spawn_in_place && Game.navmap.is_cell_navigable(current_cell):
		possible_cells.append(current_cell)
			
	if possible_cells.size() == 0:
		return Game.INVALID_CELL
	return possible_cells[randi() % possible_cells.size()]


func _start_timer() -> void:
	timer.start(rng.randf_range(min_time, max_time))


func _setup_timer() -> void:
	add_child(timer)
	timer.connect("timeout", self, "_on_timer_timeout")
	timer.one_shot = true
	


func _on_timer_timeout() -> void:
	secrete_entity()
	_start_timer()








