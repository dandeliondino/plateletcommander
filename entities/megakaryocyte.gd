extends TextureRect

var BuddingPlatelet := preload("res://entities/platelet/budding_platelet.tscn")
var ReadyPlatelet := preload("res://entities/platelet/ready_platelet.tscn")

var budding_spots := {}
var current_spot : Node

onready var timer := $"%Timer"
onready var timerLabel := $"%TimerLabel"

func _ready() -> void:
	Events.connect("platelet_dropped", self, "_on_Events_platelet_dropped")
	var nodes = get_tree().get_nodes_in_group("budding_spot")
	for node in nodes:
		budding_spots[node] = null
	start_budding()

func _process(delta: float) -> void:
	timerLabel.text = str(ceil(timer.time_left))

func start_budding() -> void:
	current_spot = get_next_budding_spot()
	if current_spot == null:
		return
	var new_bud = BuddingPlatelet.instance()
#	new_bud.rect_global_position = current_spot.global_position
	current_spot.add_child(new_bud)
#	add_child(new_bud)
	budding_spots[current_spot] = new_bud



func mature_bud() -> void:
	var new_platelet = ReadyPlatelet.instance()
#	new_platelet.rect_global_position = current_spot.global_position
	current_spot.add_child(new_platelet)
	budding_spots[current_spot].queue_free()
	budding_spots[current_spot] = new_platelet


func get_next_budding_spot():
	var empty_spots := []
	for spot in budding_spots.keys():
		if budding_spots[spot]:
			continue
		empty_spots.append(spot)
	if empty_spots.size() == 0:
		return null
	
	return empty_spots[randi() % empty_spots.size()]





func _on_Timer_timeout() -> void:
	if current_spot:
		mature_bud()
	start_budding()

func _on_Events_platelet_dropped(node : Node) -> void:
	assert(node in budding_spots.keys())
	budding_spots[node].queue_free()
	budding_spots[node] = null
