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
var current_level := ""

var connections_made := 0
var connections_upgraded := 0

var selected_entity = null

# NODES
var navmap
var entity_container : Node2D
var camera : Camera2D
var camera_limits : ReferenceRect

var connection_line : Line2D

var tooltip

var settings

var ink_manager


# GROUPS
# put group strings here
const ENTITY_GROUP := "entities"
const PLATELET_GROUP := "platelets"
const POWERUP_GROUP := "powerups"
const DAMAGED_ENDOTHELIUM_GROUP := "damaged_endothelium"
const RBC_GROUP := "rbcs"
const OFF_SCREEN_GROUP := "off_screen_area"
const CONNECTION_GROUP := "connection_controls"


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


