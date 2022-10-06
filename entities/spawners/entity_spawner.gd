extends Node2D

export(Game.ENTITY) var entity_id : int
export(String, FILE) var entity_to_secrete_path : String
export(float) var min_time := 3.0
export(float) var max_time := 20.0
export(bool) var limit_direction := false
export(Game.DIRECTION) var direction_to_secrete
export(bool) var active := true

var entity_container : Node2D

onready var entity_to_secrete := load(entity_to_secrete_path)
onready var timer := Timer.new()
onready var rng = RandomNumberGenerator.new()


func _ready() -> void:
	rng.randomize()
	_setup_timer()
	
	if !Game.level_loaded:
		yield(Events, "level_loaded")
	entity_container = Game.level.entity_spawns[entity_id].container
		
	if active:
		_start_timer()

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
	if limit_direction:
		var target_cell = Game.navmap.get_neighbor_cell(_get_current_cell(), direction_to_secrete)
		if Game.navmap.is_cell_navigable(target_cell):
			return target_cell
		else:
			return Game.INVALID_CELL
	
	var possible_cells = Game.navmap.get_neighbors(_get_current_cell(), true)
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








