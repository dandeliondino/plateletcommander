extends Node

const QUEST_DATA_PATH = "quest_data"
const MAP_DATA_PATH = "map_data"

onready var inkPlayer := $"%InkPlayer"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.ink_manager = self
	bind_external_functions()

	
func follow_path(path : String) -> void:
	inkPlayer.ChoosePathString(path)
	while inkPlayer.CanContinue:
		inkPlayer.Continue()
	

func get_text(path : String) -> String:
	return _get_text_from_path(path)

# returns an array of dicts to populate quest journal
func get_quests() -> Array:
	var json = _get_json_from_path(QUEST_DATA_PATH)
	var quests = json.result["quests"]
	return quests





# HELPER FUNCTIONS
func _get_json_from_path(path : String) -> JSONParseResult:
	return JSON.parse(_get_text_from_path(path))


func _get_text_from_path(path : String) -> String:
	var text := ""
	
	inkPlayer.ChoosePathString(path)
	while inkPlayer.CanContinue:
		inkPlayer.Continue()
		text += inkPlayer.CurrentText
	
	return text


# EXTERNAL FUNCTIONS

func bind_external_functions() -> void:
	pass

func _update_journal() -> void:
	Events.emit_signal("journal_update_requested")
