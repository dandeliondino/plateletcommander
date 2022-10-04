class_name Settings
extends Node

export(float) var passive_movement_speed := 1.0 # seconds per tile

export(float) var tooltip_time := 3.0 # seconds before fading away

export(bool) var show_navmap := false

export(bool) var debug_keys := true

export(float) var fade_to_black_time := 0.5
export(float) var fade_to_game_time := 1.0

export(String, DIR) var level_directory
export(String, FILE) var new_game_level


func _ready():
	Game.settings = self
