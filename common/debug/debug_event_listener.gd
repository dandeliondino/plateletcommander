extends Node

export(bool) var print_event_signals := true

var debug_event_category = "EVENT"

var event_signals = [

# LEVELS
"level_change_requested",
"level_changing",
"level_unloading",
"level_unloaded",
"level_loading",
"level_loaded",

"fade_to_black_requested",
"faded_to_black",
"fade_to_game_requested",
"faded_to_game",



# UI
"game_state_exit_requested",
"game_state_change_requested",
"game_state_changed",

# Menus/Panels
"main_menu_requested",
# put panel requests here

# ConfirmationBox
"confirmation_popup_requested",
"confirmation_option_chosen",

# Entities
"entity_selected",
#"entity_focus_gained",
#"entity_focus_lost",
"entity_cell_changed",

]


func _ready():
	connect_signals()


func connect_signals():
	for signal_name in event_signals:
		Events.connect(signal_name, self, "_on_Events_signal_emitted", [signal_name])


func _on_Events_signal_emitted(arg1, arg2=null, arg3=null, arg4=null, arg5=null):
	var args = [arg1, arg2, arg3, arg4, arg5]
	while args.has(null):
		args.erase(null)
	
	if args.size() == 1:
		Dprint.info(args[0], debug_event_category)
	else:
		var signal_name = args.pop_back()
		Dprint.info("%s (%s)" % [signal_name, args], debug_event_category)	
