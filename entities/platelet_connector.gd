extends Connection_Receiver



func get_drag_data(position: Vector2):	
	assert(entity.can_connect)
	if !entity.can_connect:
		return
	
#	var textrect = TextureRect.new()
#	textrect.texture = powerup_texture
#	set_drag_preview(textrect)

	
	
	return {
		"drop_type": Game.DROP_TYPES.CONNECTOR,
		"entity": entity,
	}





