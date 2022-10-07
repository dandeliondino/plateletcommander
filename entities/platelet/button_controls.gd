extends Control

var entity_id : int

onready var moveButton := $"%MoveButton"
onready var activateButton := $"%ActivateButton"
onready var connectButton := $"%ConnectButton"
onready var upgradeButton := $"%UpgradeButton"

func _ready() -> void:
	hide()


func setup_controls(entity_id_value : int) -> void:
	entity_id = entity_id_value
	if entity_id == Game.ENTITY.PLATELET:
		setup_resting_platelet_controls()
	elif entity_id == Game.ENTITY.ACTIVATED_PLATELET:
		setup_activated_platelet_controls()

func setup_resting_platelet_controls() -> void:
	connectButton.hide()
	upgradeButton.hide()

func setup_activated_platelet_controls() -> void:
	activateButton.hide()


func show_controls() -> void:
	if Game.inventory[Game.POWERUP.ACTIVATE] >= 1:
		activateButton.disabled = false
	else:
		activateButton.disabled = true
	connectButton.disabled = true
	upgradeButton.disabled = true
	show()

func _on_MoveButton_pressed() -> void:
	hide()
	Events.emit_signal("move_state_requested")


func _on_ActivateButton_pressed() -> void:
	Events.emit_signal("apply_powerup_requested", Game.POWERUP.ACTIVATE)
