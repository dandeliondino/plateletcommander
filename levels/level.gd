class_name Level
extends ResourceScene


onready var entity_spawns := {
	Game.ENTITY.PLATELET: {
		"max": 20,
		"container": $"%PlateletContainer",
	},
	Game.ENTITY.RBC: {
		"max": 3,
		"container": $"%RBCContainer",
	},
	Game.ENTITY.ACTIVATION_POTION: {
		"max": 5,
		"container": $"%PowerupContainer",
	},
	Game.ENTITY.FIBRIN_POTION: {
		"max": 5,
		"container": $"%PowerupContainer",
	},
	Game.ENTITY.XLINK_POTION: {
		"max": 5,
		"container": $"%PowerupContainer",
	},
}


onready var default_width = ProjectSettings.get_setting("display/window/size/width")
onready var default_height = ProjectSettings.get_setting("display/window/size/height")

onready var camera_limits = get_node_or_null("%CameraLimits") # optional
onready var navmap := get_node_or_null("%NavMap")


func _ready() -> void:	
	assert(navmap != null, "Unable to find scene unique name 'NavMap' for level")
	Game.level = self
	Game.navmap = navmap
	Game.camera_limits = camera_limits

	
	center_level()
	Game.world.connect("resized", self, "_on_World_resized")

func center_level() -> void:
	Dprint.info("world resized: %s" % [Game.world.rect_size])

	get_tree().paused = true
	Events.emit_signal("fade_to_black_requested")
	yield(Events, "faded_to_black")
	
	var x = round((Game.world.rect_size.x - default_width)/2)
	var y = round((Game.world.rect_size.y - default_height)/2)
	global_position = Vector2(x,y)
	
	yield(get_tree(), "idle_frame")	
	get_tree().call_group(Game.ENTITY_GROUP, "set_position_to_current_cell")
	yield(get_tree(), "idle_frame")
	get_tree().call_group(Game.PASSIVE_MOVER_GROUP, "try_to_move")
	yield(get_tree(), "idle_frame")

	Events.emit_signal("fade_to_game_requested")
	yield(Events, "faded_to_game")
	get_tree().paused = false


func _on_World_resized() -> void:
	center_level()




