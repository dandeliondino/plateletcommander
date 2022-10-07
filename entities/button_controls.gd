extends Control

var entity_id : int
var entity : Node2D

onready var moveButton := $"%MoveButton"
onready var activateButton := $"%ActivateButton"
onready var connectButton := $"%ConnectButton"
onready var upgradeButton := $"%UpgradeButton"

func _ready() -> void:
	hide()


func setup(entity_value, entity_id_value : int) -> void:
	entity = entity_value
	entity_id = entity_id_value
	
	if !entity.can_connect:
		connectButton.queue_free()
	if !entity.can_activate:
		activateButton.queue_free()
	if !entity.can_move:
		moveButton.queue_free()
	if !entity.can_upgrade:
		upgradeButton.queue_free()



func show_controls() -> void:
	if is_instance_valid(activateButton):
		if Game.inventory[Game.POWERUP.ACTIVATE] >= 1:
			activateButton.disabled = false
		else:
			activateButton.disabled = true
	
	if is_instance_valid(connectButton):
		connectButton.disabled = true
	
	if is_instance_valid(upgradeButton):
		upgradeButton.disabled = true
	
	show()

func _on_MoveButton_pressed() -> void:
	hide()
	Events.emit_signal("move_state_requested")


func _on_ActivateButton_pressed() -> void:
	Events.emit_signal("apply_powerup_requested", Game.POWERUP.ACTIVATE)
