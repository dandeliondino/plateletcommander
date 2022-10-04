extends Control

var Platelet := preload("res://entities/platelet/platelet.tscn")

var target_cell : Vector2

onready var entity_container := $"%Entities"
onready var node2d := $Node2D

func drop_data(_position: Vector2, data) -> void:
	var platelet = Platelet.instance()
	var pos = Game.navmap.get_position_at_cell(target_cell)
	platelet.global_position = pos
	entity_container.add_child(platelet)
	Events.emit_signal("platelet_dropped", data.spot)


func can_drop_data(position: Vector2, data) -> bool:
	Game.connection_line.hide()
	
	if typeof(data) != TYPE_DICTIONARY:
		return false
		
	if !data.has("drop_type") or data.drop_type != Game.DROP_TYPES.PLATELET:
		return false
	
	target_cell = Game.navmap.get_cell_at_position(node2d.to_global(position))
	if !Game.navmap.is_cell_navigable(target_cell):
		return false
	
	return true

