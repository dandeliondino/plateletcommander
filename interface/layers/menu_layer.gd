extends CanvasLayer

onready var mainMenu := $"%MainMenu"

onready var panels := [mainMenu]


func _ready():
	Events.connect("main_menu_requested", self, "_on_panel_requested", [mainMenu])



func open_panel(panel : Control) -> void:
	Events.emit_signal("game_state_change_requested", Game.states.MENU)
	for p in panels:
		if p == panel:
			p.show()
		else:
			p.hide()


func _on_panel_requested(panel : Control) -> void:
	open_panel(panel)	









