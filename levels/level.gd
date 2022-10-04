class_name Level
extends ResourceScene

onready var camera_limits = get_node_or_null("%CameraLimits") # optional
onready var navmap := get_node_or_null("%NavMap")

func _ready() -> void:	
	assert(navmap != null, "Unable to find scene unique name 'NavMap' for level")
	Game.navmap = navmap
	Game.camera_limits = camera_limits
	Game.entity_container = $"%Entities"

