extends CanvasLayer

var ConfirmationBox := preload("res://interface/confirmation_box/confirmation_box.tscn")

var confirmationBox : Container


onready var confirmationBoxContainer := $"%ConfirmationBoxContainer"


func _ready() -> void:
	Events.connect("confirmation_popup_requested", self, "_on_Events_confirmation_popup_requested")


func _open_confirmation_box(params : Dictionary) -> void:
	Events.emit_signal("game_state_change_requested", Game.states.CONFIRMATION_BOX)
	
	confirmationBox = ConfirmationBox.instance()
	confirmationBoxContainer.add_child(confirmationBox)
	confirmationBox.setup(params)
	confirmationBox.connect("option_chosen", self, "_on_ConfirmationBox_option_chosen")


func _close_confirmation_box():
	Events.emit_signal("game_state_exit_requested")
	confirmationBox.queue_free()
	
	

func _on_Events_confirmation_popup_requested(params : Dictionary) -> void:
	_open_confirmation_box(params)


func _on_ConfirmationBox_option_chosen(value : int) -> void:
	Events.emit_signal("confirmation_option_chosen", value)
	_close_confirmation_box()
