class_name MouseOverControl
extends Control

export(String) var ink_path : String

func _ready() -> void:
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")

func get_tooltip_text() -> String:
	return Game.ink_manager.get_text(ink_path + ".tooltip")


func _on_mouse_entered() -> void:
	Game.tooltip.show_tooltip(self, get_tooltip_text(), ink_path)




func _on_mouse_exited() -> void:
	Game.tooltip.hide_immediately(self)
