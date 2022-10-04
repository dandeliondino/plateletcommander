class_name ResourceScene
extends Node


var id : String setget , get_id
func get_id() -> String:
	return Utils.filepath_to_filename(filename)
