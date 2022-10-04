class_name Connection_Receiver
extends Node

onready var entity : Entity = get_parent()


func drop_data(_position: Vector2, data) -> void:
	var result = entity.make_connection_to(data.entity)
	Game.connection_line.hide()
	print("Connection success: %s" % result)
	print(entity._connections)


func can_drop_data(position: Vector2, data) -> bool:
	if typeof(data) != TYPE_DICTIONARY:
		return false
		
	if !data.has("drop_type") or data.drop_type != Game.DROP_TYPES.CONNECTOR:
		return false
	
	var connecting_entity : Entity = data.entity
	if entity == connecting_entity:
		Game.connection_line.hide()
		return false
	
	if !entity.can_connect_to(connecting_entity):
		Game.connection_line.show_as_invalid(entity, connecting_entity)
		return false
	
	if !connecting_entity.can_connect_to(entity):
		Game.connection_line.show_as_invalid(entity, connecting_entity)
		return false

	Game.connection_line.show_as_valid(entity, connecting_entity)
	return true
