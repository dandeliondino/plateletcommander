class_name RBC_Entity
extends Entity

enum states {NONE, WAITING, MOVING, CLOTTED, TRAPPED}
var state : int = states.WAITING setget set_state
func set_state(value : int) -> void:
	if value == state:
		return
	state = value
	

var movement_attempts := 0
var max_movement_attempts = 10


func _ready() -> void:
	self.group = Game.RBC_GROUP
	self.can_hover = true
	self.can_connect = true
	connect("movement_completed", self, "_on_movement_completed")


func _physics_process(delta: float) -> void:	
	if state == states.WAITING:
		var next_target = _get_next_target_cell()
		if next_target == Game.INVALID_CELL:
			movement_attempts += 1
			if movement_attempts >= max_movement_attempts:
				self.state = states.TRAPPED
				Dprint.warning("%s is trapped" % name)
			return
			
		self.state = states.MOVING
		move_to_cell(next_target)
		


func _get_next_target_cell() -> Vector2:
	var directions_to_check = [Game.DIRECTION.RIGHT, Game.DIRECTION.UP, Game.DIRECTION.DOWN, Game.DIRECTION.LEFT]
	if (randi() % 2):
		directions_to_check = [Game.DIRECTION.RIGHT, Game.DIRECTION.DOWN, Game.DIRECTION.UP, Game.DIRECTION.LEFT]

	var next_target : Vector2
	
	for dir in directions_to_check:
		next_target = Game.navmap.get_neighbor_cell(cell, dir)
		if Game.navmap.is_cell_navigable(next_target):
			return next_target
	
	return Game.INVALID_CELL


func _on_connection_made(entity : Entity, dir : int) -> void:
	self.state = states.CLOTTED
	if tween:
		tween.kill()
	tween = create_tween()
	# TODO clean up tweens
	tween.tween_property(self, "global_position", Game.navmap.get_position_at_cell(cell), speed)

func _on_movement_completed() -> void:
	if self.state == states.MOVING:
		self.state = states.WAITING
