class_name Powerup_Entity
extends Entity


func _ready() -> void:
	self.group = Game.POWERUP_GROUP


func can_interact() -> bool:
	if Game.selected_entity.state == Platelet_Entity.states.RESTING:
		return true
	return false


func interact() -> void:
	Game.selected_entity.state = Platelet_Entity.states.ACTIVATED
	remove_from_map()
