extends Entity

var ActivatedPlatelet := preload("res://entities/platelet/activated_platelet.tscn")

func apply_powerup(id : int) -> void:
	if id != Game.POWERUP.ACTIVATE:
		Dprint.warning("Attempted to apply wrong power up")
		return
	
	replace_with(ActivatedPlatelet)
	
	
