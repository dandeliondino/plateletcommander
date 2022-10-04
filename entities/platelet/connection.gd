extends Control

export(Game.DIRECTION) var direction : int

var entity : Entity

onready var baseConnection := $"%BaseConnection"
onready var fibrinConnection := $"%FibrinConnection"
onready var xlinkConnection := $"%XLinkConnection"

func _ready() -> void:
	add_to_group(Game.CONNECTION_GROUP)
	baseConnection.hide()
	baseConnection.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fibrinConnection.hide()
	fibrinConnection.mouse_filter = Control.MOUSE_FILTER_IGNORE
	xlinkConnection.hide()
	xlinkConnection.mouse_filter = Control.MOUSE_FILTER_IGNORE


func show_as_connected() -> void:
	baseConnection.show()
	baseConnection.mouse_filter = Control.MOUSE_FILTER_STOP
	entity._connections[direction].strength = entity.connection_strengths.PLUG
	entity.fibrinPowerupSecretor.activate()

func apply_powerup(powerup_id : int) -> void:
	if powerup_id == Game.POWERUP.FIBRIN:
		upgrade_to_fibrin()
	if powerup_id == Game.POWERUP.XLINK:
		upgrade_to_xlink()
	Events.emit_signal("connection_upgraded")


func upgrade_to_fibrin() -> void:
	baseConnection.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fibrinConnection.show()
	fibrinConnection.mouse_filter = Control.MOUSE_FILTER_STOP
	entity._connections[direction].strength = entity.connection_strengths.FIBRIN
	entity.xlinkPowerupSecretor.activate()

func upgrade_to_xlink() -> void:
	fibrinConnection.mouse_filter = Control.MOUSE_FILTER_IGNORE
	xlinkConnection.show()
	entity._connections[direction].strength = entity.connection_strengths.XLINK
