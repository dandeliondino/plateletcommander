class_name Platelet
extends Entity



func _ready() -> void:
	buttonControls.setup_controls(group_id)

func apply_powerup(id : int) -> void:
	# override this function
	pass


func _on_selected() -> void:
	Events.connect("apply_powerup_requested", self, "_on_Events_apply_powerup_requested")
	get_parent().move_child(self, get_parent().get_child_count()-1)
	if is_instance_valid(passive_mover):
		passive_mover.pause()
	buttonControls.show_controls()
	

func _on_deselected() -> void:
	if Events.is_connected("apply_powerup_requested", self, "_on_Events_apply_powerup_requested"):
		Events.disconnect("apply_powerup_requested", self, "_on_Events_apply_powerup_requested")
	if is_instance_valid(passive_mover):
		passive_mover.unpause()
	buttonControls.hide()

	
func _on_Events_apply_powerup_requested(powerup_id : int) -> void:
	apply_powerup(powerup_id)
