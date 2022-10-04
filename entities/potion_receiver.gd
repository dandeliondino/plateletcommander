extends Control

export(Game.POWERUP) var powerup_to_receive

var tween : SceneTreeTween


func drop_data(_position: Vector2, data) -> void:
	get_parent().apply_powerup(data.powerup_id)


func can_drop_data(position: Vector2, data) -> bool:
	if typeof(data) != TYPE_DICTIONARY:
		return false
		
	if !data.has("drop_type") or data.drop_type != Game.DROP_TYPES.POWERUP:
		return false
	
	if data.powerup_id != powerup_to_receive:
		show_owner_as_disabled()
		return false

	show_owner_as_enabled()
	return true


func show_owner_as_enabled() -> void:
	modulate_owner(Color("#509134"))

func show_owner_as_disabled() -> void:
	modulate_owner(Color("#be2633"))

func modulate_owner(color : Color) -> void:
	owner.modulate = color
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_interval(0.5)
	tween.tween_property(owner, "modulate", Color.white, 0.25)
	
	
	
	
