class_name Level
extends ResourceScene

var width = 640
var height = 360

onready var camera_limits = get_node_or_null("%CameraLimits") # optional
onready var navmap := get_node_or_null("%NavMap")

func _ready() -> void:	
	assert(navmap != null, "Unable to find scene unique name 'NavMap' for level")
	Game.navmap = navmap
	Game.camera_limits = camera_limits
	Game.entity_container = $"%Entities"
	
	center_level()
	Game.world.connect("resized", self, "_on_World_resized")

func center_level() -> void:
	Dprint.info("world resized: %s" % [Game.world.rect_size])
	report_endothelium_cells()
	get_tree().paused = true
	Events.emit_signal("fade_to_black_requested")
	yield(Events, "faded_to_black")
	var x = round((Game.world.rect_size.x - width)/2)
	var y = round((Game.world.rect_size.y - height)/2)
	global_position = Vector2(x,y)
	yield(get_tree(), "idle_frame")
	for entity in get_tree().get_nodes_in_group(Game.ENTITY_GROUP):
		entity.set_position_to_current_cell()
#	Game.navmap.reset_map()
	Events.emit_signal("fade_to_game_requested")
	yield(Events, "faded_to_game")
	get_tree().paused = false
	report_endothelium_cells()

func report_endothelium_cells() -> void:
	for node in get_tree().get_nodes_in_group(Game.DAMAGED_ENDOTHELIUM_GROUP):
		Dprint.info("Damaged endothelium cell: %s" % node.cell)

func _on_World_resized() -> void:
	center_level()




