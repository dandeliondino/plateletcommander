extends Platelet

var ActivatedPlatelet := preload("res://entities/platelet/activated_platelet.tscn")


func apply_powerup(id : int) -> void:
	if id != Game.POWERUP.ACTIVATE:
		Dprint.warning("Attempted to apply wrong power up")
		return
		
	Events.emit_signal("powerup_used", Game.POWERUP.ACTIVATE)
	replace_with(ActivatedPlatelet)
	

