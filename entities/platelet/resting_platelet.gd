extends Entity

var ActivatedPlatelet := preload("res://entities/platelet/activated_platelet.tscn")

func apply_powerup(id : int) -> void:
	if id != Game.POWERUP.ACTIVATE:
		Dprint.warning("Attempted to apply wrong power up")
		return
	
	replace_with(ActivatedPlatelet)
	
func _on_selected() -> void:
	if is_instance_valid(passive_mover):
		passive_mover.pause()

func _on_deselected() -> void:
	if is_instance_valid(passive_mover):
		passive_mover.unpause()
