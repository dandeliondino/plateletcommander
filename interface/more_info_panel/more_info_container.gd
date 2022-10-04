extends Control

onready var moreInfoPanel := $MoreInfoPanel

func _ready() -> void:
	Events.connect("more_info_panel_requested", self, "_on_Events_more_info_panel_requested")
	moreInfoPanel.hide()

func show_more_info_panel(path : String) -> void:
	Game.tooltip.hide_immediately()
	var title : String = Game.ink_manager.get_text(path + ".more_info_title")
	var text : String = Game.ink_manager.get_text(path + ".more_info")
	text = text.replace("\n", "\n\n")
	moreInfoPanel.display_panel(title, text)


func _on_Events_more_info_panel_requested(path : String) -> void:
	show_more_info_panel(path)
