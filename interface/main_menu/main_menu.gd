extends PanelContainer

onready var newGameButton := $"%NewGameButton"
onready var returnButton := $"%ReturnButton"
onready var exitButton := $"%ExitButton"


func update_buttons() -> void:
	if Game.started:
		newGameButton.hide()
		returnButton.show()
	else:
		newGameButton.show()
		returnButton.hide()
	if OS.has_feature("HTML5"):
		exitButton.hide()


func _on_ExitButton_pressed():
	Events.emit_signal("confirmation_popup_requested", {
		"title": "Quit game?",
		"options": [
			"CANCEL",
			"QUIT",
		]
	})
	var result = yield(Events, "confirmation_option_chosen")
	if result == 0:
		return
	else:
		get_tree().quit()


func _on_NewGameButton_pressed():
	Events.emit_signal("level_change_requested", Game.settings.new_game_level)


func _on_ReturnButton_pressed():
	Events.emit_signal("game_state_change_requested", Game.states.WORLD)


func _on_MainMenu_visibility_changed():
	if is_visible_in_tree():
		update_buttons()



func _on_AboutButton_pressed() -> void:
	Events.emit_signal("game_state_change_requested", Game.states.ABOUT_MENU)


func _on_RestartButton_pressed() -> void:
	Events.emit_signal("confirmation_popup_requested", {
		"title": "Restart game?",
		"options": [
			"CANCEL",
			"RESTART",
		]
	})
	var result = yield(Events, "confirmation_option_chosen")
	if result == 0:
		return
	else:
		Events.emit_signal("level_change_requested", Game.settings.new_game_level)
