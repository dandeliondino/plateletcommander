extends Node

onready var state_data := {
	Game.states.PRELOAD: {
		"layers": [],
		"pause_tree": false,
		"valid_previous_state": false,
	},
	Game.states.WORLD: {
		"layers": [$"%WorldLayer", $"%HUDLayer"],
		"pause_tree": false,
		"valid_previous_state": true,
	},
	Game.states.MENU: {
		"layers": [$"%MenuLayer"],
		"pause_tree": true,
		"valid_previous_state": true,
	},
	Game.states.ABOUT_MENU: {
		"layers": [$"%AboutLayer"],
		"pause_tree": true,
		"valid_previous_state": false,
	},
	Game.states.CONFIRMATION_BOX: {
		"layers": [$"%ConfirmationBoxLayer"],
		"pause_tree": true,
		"valid_previous_state": false,
	},
}


var _previous_states = []
var previous_state

func _ready() -> void:
	Events.connect("game_state_change_requested", self, "_on_Events_game_state_change_requested")
	Events.connect("game_state_exit_requested", self, "_on_Events_game_state_exit_requested")
	yield(owner, "ready")
	Events.emit_signal("main_menu_requested")


func _get_last_valid_state():
	for i in range(_previous_states.size()-1, 0, -1):
		var state = _previous_states[i]
		if state != Game.state && state_data[state].valid_previous_state:
			return state
	assert(false, "No valid previous state found")
	

func _exit_game_state() -> void:
	_change_game_state(_get_last_valid_state())

func _change_game_state(new_state) -> void:
	_previous_states.append(Game.state)
	Game.state = new_state
	
	_update_layer_visibility()
	_update_tree_paused()
	
	Events.emit_signal("game_state_changed", previous_state, new_state)


func _update_layer_visibility():
	for game_state in Game.states.values():
		if game_state == Game.state:
			_toggle_layer_visibility(game_state, true)
		elif game_state > Game.state:
			_toggle_layer_visibility(game_state, false)


func _toggle_layer_visibility(game_state, value : bool) -> void:
	for layer in state_data[game_state].layers:
		layer.visible = value



func _update_tree_paused() -> void:
	if state_data[Game.state].pause_tree:
		get_tree().paused = true
	else:
		get_tree().paused = false





func _on_Events_game_state_change_requested(value : int) -> void:
	if value == Game.state:
		return

	_change_game_state(value)



func _on_Events_game_state_exit_requested() -> void:
	_exit_game_state()











