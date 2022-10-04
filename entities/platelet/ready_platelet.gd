extends MouseOverControl


onready var textureRect := $TextureRect

func get_drag_data(position: Vector2):	
	var textrect = TextureRect.new()
	textrect.texture = textureRect.texture
	set_drag_preview(textrect)
	
	return {
		"drop_type": Game.DROP_TYPES.PLATELET,
		"spot": get_parent(),
	}
	
