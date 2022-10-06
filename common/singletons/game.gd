extends Node

# CONSTANTS
const ALIGN_HORIZONTAL = 0
const ALIGN_VERTICAL = 1
const INVALID_NEIGHBOR := -1
const INVALID_CELL := Vector2.INF
const INVALID_PATH := PoolVector2Array()

# GAME STATE
enum states {PRELOAD, WORLD, MENU, ABOUT_MENU, CONFIRMATION_BOX}
var state = states.PRELOAD
var faded_to_black := false
var started := false
var level_loaded := false
var current_level := ""

var level

var connections_made := 0
var connections_upgraded := 0

var selected_entity = null

# NODES
var navmap

var camera : Camera2D
var camera_limits : ReferenceRect

var connection_line : Line2D

var tooltip

var settings

var ink_manager
var world


# GROUPS
const ENTITY_GROUP := "entities"
const CONNECTION_GROUP := "connection_controls"

const OFF_MAP_AREA := "off_map_areas"
const PASSIVE_MOVER_GROUP := "passive_movers"

# ENTITIES
enum ENTITY {PLATELET, RBC, DAMAGED_ENDOTHELIUM, ACTIVATION_POTION, FIBRIN_POTION, XLINK_POTION}




# CONSTANTS
enum DIRECTION {LEFT, UP_LEFT, UP, UP_RIGHT, RIGHT, DOWN_RIGHT, DOWN, DOWN_LEFT}


# POWERUP INVENTORY
enum POWERUP {ACTIVATE, FIBRIN, XLINK}

var inventory := {
	POWERUP.ACTIVATE: 3,
	POWERUP.FIBRIN: 2,
	POWERUP.XLINK: 0,
}


# DROP
enum DROP_TYPES {POWERUP, PLATELET, CONNECTOR}

# drop_data = {"drop_type": DROP_TYPES.POWERUP, ...}


