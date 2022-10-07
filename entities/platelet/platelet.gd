class_name Platelet
extends Entity



func _ready() -> void:
	pass

func apply_powerup(id : int) -> void:
	# override this function
	pass


func _on_selected() -> void:
	Events.connect("apply_powerup_requested", self, "_on_Events_apply_powerup_requested")

func _on_deselected() -> void:
	if Events.is_connected("apply_powerup_requested", self, "_on_Events_apply_powerup_requested"):
		Events.disconnect("apply_powerup_requested", self, "_on_Events_apply_powerup_requested")


	
func _on_Events_apply_powerup_requested(powerup_id : int) -> void:
	apply_powerup(powerup_id)
