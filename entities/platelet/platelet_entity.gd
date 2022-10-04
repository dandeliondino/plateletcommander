class_name Platelet_Entity
extends Entity

enum states {RESTING, ACTIVATED, CONNECTED}
var state : int = states.RESTING setget set_state
func set_state(value : int) -> void:
	if value == state:
		return
	if state == states.RESTING && value == states.ACTIVATED:
		_transition_resting_to_activated()
	if state == states.ACTIVATED && value == states.CONNECTED:
		_transition_activated_to_connected()
	state = value




onready var animationPlayer := $AnimationPlayer
onready var connectionSpriteContainer := $ConnectionSprites

func _ready() -> void:
	self.group = Game.PLATELET_GROUP
	self.can_select = true
	self.can_hover = true
	self.can_move = true
	
	_connections[Game.DIRECTION.LEFT].sprite = $"%ConnectionL"
	_connections[Game.DIRECTION.UP_LEFT].sprite = $"%ConnectionUL"
	_connections[Game.DIRECTION.UP].sprite = $"%ConnectionU"
	_connections[Game.DIRECTION.UP_RIGHT].sprite = $"%ConnectionUR"
	_connections[Game.DIRECTION.RIGHT].sprite = $"%ConnectionR"
	_connections[Game.DIRECTION.DOWN_RIGHT].sprite = $"%ConnectionDR"
	_connections[Game.DIRECTION.DOWN].sprite = $"%ConnectionD"
	_connections[Game.DIRECTION.DOWN_LEFT].sprite = $"%ConnectionDL"
	
	for node in connectionSpriteContainer.get_children():
		node.hide()
	connectionSpriteContainer.show()


func _on_connection_made(entity : Entity, dir : int) -> void:
	self.state = states.CONNECTED




func _transition_resting_to_activated() -> void:
	animationPlayer.play("activate")
	self.can_connect = true

func _transition_activated_to_connected() -> void:
	self.can_move = false
	self.can_drop_fibrin = true


func get_ink_path() -> String:
	if state == states.RESTING:
		return "resting_platelet"
	else:
		return "activated_platelet"





