extends Node2D

export(float) var wait_time_if_stuck := 2.0
export(int) var wait_loops_if_stuck := 10


onready var entity : Entity = get_parent()


func _ready() -> void:
	entity.connect("movement_completed", self, "_on_Entity_movement_completed") 
	entity.connect("became_clotted", self, "_on_Entity_became_clotted")
	
	if !Game.started:
		yield(Events, "level_loaded")
	yield(get_tree(), "idle_frame")
	move()


func move():
	var target_cell = _get_next_target_cell()
	if target_cell != Game.INVALID_CELL:
		entity.move_to_cell(target_cell)
		return
	
	var i := 0
	while target_cell == Game.INVALID_CELL:
		i += 1
		if i >= wait_loops_if_stuck:
			Dprint.warning("Entity stuck and cannot move, giving up")
			return
		yield(get_tree().create_timer(wait_time_if_stuck), "timeout")
		target_cell = _get_next_target_cell()
	
	entity.move_to_cell(target_cell)
	

func _get_next_target_cell() -> Vector2:
	var directions_to_check = [Game.DIRECTION.RIGHT, Game.DIRECTION.UP, Game.DIRECTION.DOWN, Game.DIRECTION.LEFT]
	if (randi() % 2):
		directions_to_check = [Game.DIRECTION.RIGHT, Game.DIRECTION.DOWN, Game.DIRECTION.UP, Game.DIRECTION.LEFT]

	var next_target : Vector2
	
	for dir in directions_to_check:
		next_target = Game.navmap.get_neighbor_cell(entity.cell, dir)
		if Game.navmap.is_cell_navigable(next_target):
			return next_target
	
	return Game.INVALID_CELL


func _on_Entity_movement_completed() -> void:
	move()

func _on_Entity_became_clotted() -> void:
	queue_free()


func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group(Game.OFF_SCREEN_GROUP):
		entity.remove_from_map()

