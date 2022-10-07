extends Control

var requesting_node : Node
onready var label : RichTextLabel = $"%TooltipLabel"


func _ready() -> void:
	Game.tooltip = self
	label.hide()


func show_tooltip(node : Node, text_value : String, more_info_path := "") -> void:
	requesting_node = node
	if !node.is_connected("tree_exiting", self, "_on_node_tree_exiting"):
		node.connect("tree_exiting", self, "_on_node_tree_exiting", [node])
	
	label.bbcode_text = text_value.replace("[b]", "[color=#f4b41b]").replace("[/b]", "[/color]")
	label.bbcode_enabled = true
	label.show()


func hide_tooltip(node = null) -> void:
	if node != null && node != requesting_node:
		# ok to call anonymously
		# but if you are the originator check to make sure it's still your tooltip you're hiding
		return
	
	label.hide()
	

func _on_node_tree_exiting(exiting_node : Node) -> void:
	hide_tooltip(exiting_node)
