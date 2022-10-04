extends Control

var Tooltip := preload("res://interface/tooltip/tooltip.tscn")

var tooltip : Control
var tween : SceneTreeTween

var requesting_node : Node

func _ready() -> void:
	Game.tooltip = self


func show_tooltip(node : Node, text : String, more_info_path := "") -> void:
	requesting_node = node
	if !node.is_connected("tree_exiting", self, "_on_node_tree_exiting"):
		node.connect("tree_exiting", self, "_on_node_tree_exiting", [node])
	
	if is_instance_valid(tooltip):
		tooltip.queue_free()
		
	var pos : Vector2	
	
	if "global_position" in node:
		pos = node.global_position
	else:
		pos = node.rect_global_position
	
	pos += Vector2(24, -24)
	
	tooltip = Tooltip.instance()
	add_child(tooltip)
	
	tooltip.setup(text, more_info_path)
	tooltip.show_at_position(pos)
	
	fade_out_tooltip()




func fade_out_tooltip() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_interval(Game.settings.tooltip_time)
	tween.tween_property(tooltip, "modulate:a", 0.0, 0.25)
	tween.tween_callback(tooltip, "queue_free")


func hide_immediately(node = null) -> void:
	if node != null && node != requesting_node:
		# ok to call anonymously
		# but if you are the originator check to make sure it's still your tooltip you're hiding
		return
	
	if !is_instance_valid(tooltip):
		return
	
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(tooltip, "modulate:a", 0.0, 0.25)
	tween.tween_callback(tooltip, "queue_free")
	

func _on_node_tree_exiting(exiting_node : Node) -> void:
	hide_immediately(exiting_node)
