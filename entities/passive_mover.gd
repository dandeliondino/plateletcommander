extends Node2D

var wait_time_before_starting := 1.0

var move_attempts := 0
var max_move_attempts := 20
var wait_time_if_stuck := 2.0

onready var entity : Entity = get_parent()
onready var timer := Timer.new()

func _ready() -> void:
	entity.connect("movement_completed", self, "_on_Entity_movement_completed") 
	entity.connect("became_clotted", self, "_on_Entity_became_clotted")
	
	_setup_timer()
	
	if !Game.started:
		yield(Events, "level_loaded")
	timer.start(wait_time_before_starting)


func _setup_timer() -> void:
	add_child(timer)
	timer.connect("timeout", self, "_on_timer_timeout")
	timer.one_shot = true
	

func try_to_move() -> void:
	var target_cell = _get_next_target_cell()
	if target_cell == Game.INVALID_CELL:
		move_attempts += 1
		if move_attempts < max_move_attempts:
			timer.start(wait_time_if_stuck)
		else:
			Dprint.warning("Entity stuck and cannot move, giving up")
		return
	
	move_attempts = 0
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
	try_to_move()


func _on_Entity_became_clotted() -> void:
	queue_free()


func _on_timer_timeout() -> void:
	try_to_move()


func _on_Area2D_area_entered(area: Area2D) -> void:
	pass
#	if area.is_in_group(Game.OFF_SCREEN_GROUP):
#		entity.remove_from_map()

