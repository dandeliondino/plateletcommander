extends TextureRect

var has_fibrin := false
var has_fibrin_xlink := false

func _ready():
	$FibrinL.visible = false
	$FibrinXLink.visible = false

func drop_data(_pos, data):
	if data == Game.POWERUP_FIBRIN:
		upgrade_to_fibrin()
	if data == Game.POWERUP_FIBRIN_XLINK:
		upgrade_to_fibrin_xlink()

func upgrade_to_fibrin():
	$FibrinL.visible = true
	has_fibrin = true

func upgrade_to_fibrin_xlink():
	$FibrinXLink.visible = true
	has_fibrin_xlink = true

func can_drop_data(_pos, data):
	var can_drop := false
	if !has_fibrin && data == Game.POWERUP_FIBRIN:
		can_drop = true
	if has_fibrin && !has_fibrin_xlink && data == Game.POWERUP_FIBRIN_XLINK:
		can_drop = true
		
	if can_drop:
		modulate = Color.green
	else:
		modulate = Color.red
	return can_drop


func _on_ConnectionL_mouse_exited() -> void:
	modulate = Color.white
