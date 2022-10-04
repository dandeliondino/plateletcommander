extends CanvasLayer

onready var totalConnectionsLabel := $"%TotalConnectionsLabel"
onready var connectionsUpgradedLabel := $"%ConnectionsUpgradedLabel"

func _ready() -> void:
	Events.connect("connection_made", self, "_on_Events_connection_made")
	Events.connect("connection_upgraded", self, "_on_Events_connection_upgraded")
	Events.connect("level_loading", self, "_on_Events_level_loading")
	totalConnectionsLabel.text = "0"
	connectionsUpgradedLabel.text = "0"

func _on_MenuButton_pressed() -> void:
	Events.emit_signal("main_menu_requested")



func _on_Events_connection_made() -> void:
	Game.connections_made += 1
	totalConnectionsLabel.text = str(Game.connections_made)

func _on_Events_connection_upgraded() -> void:
	Game.connections_upgraded += 1
	connectionsUpgradedLabel.text = str(Game.connections_upgraded)

func _on_Events_level_loading() -> void:
	Game.connections_made = 0
	Game.connections_upgraded = 0
	totalConnectionsLabel.text = "0"
	connectionsUpgradedLabel.text = "0"
