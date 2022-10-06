extends Node

onready var levels := Utils.load_files_from_directory(Game.settings.level_directory)

var next_level_id : String
var previous_level_id : String

onready var world := $"%World"


func _ready() -> void:
	randomize()
	Dprint.info("Loaded levels: %s" % str(levels.keys()))
	Events.connect("level_change_requested", self, "_on_Events_level_change_requested")
	Utils.clear_children(world)


func change_level(level_id : String):
	if Utils.is_filepath(level_id):
		level_id = Utils.filepath_to_filename(level_id)
	
	assert(level_id in levels.keys(), "Level %s not found" % level_id)
	
	next_level_id = level_id
	previous_level_id = Game.current_level
	Game.level_loaded = false
	
	Events.emit_signal("fade_to_black_requested")
	Events.emit_signal("level_changing", Game.current_level, next_level_id)

	if !Game.faded_to_black:
		yield(Events, "faded_to_black")
	
	if Game.current_level == "":
		load_next_level()
	else:
		unload_current_level()
		


func unload_current_level():
	Events.emit_signal("level_unloading")
	
	Game.selected_entity = null
	
	var current_level_node : Node2D = world.get_child(0)
	if is_instance_valid(current_level_node):
		current_level_node.queue_free()
		yield(current_level_node, "tree_exited")
	Events.emit_signal("level_unloaded")
	load_next_level()


func load_next_level():
	
	Game.current_level = next_level_id
	
	Events.emit_signal("level_loading")
	
	var next_level_node = levels[next_level_id].instance()
	world.call_deferred("add_child", next_level_node)
	
	yield(next_level_node, "ready")
	Game.started = true
	Game.level_loaded = true
	Events.emit_signal("game_state_change_requested", Game.states.WORLD)
	Events.emit_signal("level_loaded")
	Events.emit_signal("fade_to_game_requested")
	




func _on_Events_level_change_requested(value : String) -> void:
	change_level(value)
