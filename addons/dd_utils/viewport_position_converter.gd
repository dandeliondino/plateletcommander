class_name ViewportPositionConverter
extends Node

# Main Scene:
# - Node2D (scene owner)
#	- ...
# 	- Viewport (size=base resolution, i.e. 320x180, flipy = true)
#		- ...
#		- LocalNode (such as a TileMap)
#		- Camera2D (current=true)
#	- CanvasLayer
#		- TextureRect (texture=viewport texture, expand=true, stretch mode=scale on expand, rect_min_size=scaled-up resolution, i.e. 640x360)

# Project Settings:
# Integer Resolution Handler (if using), base width/height = ViewportRect.rect_min_size
# Display -> Window -> Size = multiple of ViewportRect.rect_min_size
# Stretch: Mode 2D, aspect "keep" (note: "expand" not supported, will get unexpected results)

# Suggested use:
# LocalNode is the node inside a viewport that needs to know where the mouse is (such as a TileMap)
# 1. Inside LocalNode's script, crate an instance of this class:
#	var vpc := ViewportPositionConverter.new()
# 2. Initialize it with the local_node and viewport_rect:
#	vpc.setup(self, Global.viewport_rect)
# 3. Get the mouse position using local_mouse_position:
#	var mouse_pos = vpc.local_mouse_position
#	var mouse_cell = world_to_map(mouse_pos)
# 4. Get the position outside the viewport using get_external_position():
#	var cell_pos = map_to_world(cell)
#	var hud_pos = vpc.get_external_position(cell_pos)

# Notes:
# "Global" positions are not consistently defined or returned in the Godot Engine.
# For example, the return value of get_global_mouse_position() varies depends on which node is calling it.
# In the exposed functions here, Global refers to a position relative to the viewport's owner.
# Local refers to a position relative to LocalNode's canvas, and can be used to manipulate Node2Ds
# within the viewport with expected results.

# Troubleshooting:
# Was VPC initialized before local_node existed/was ready?
# Is there a Camera2D in the viewport set to current? (otherwise will be offset)

var _local_node : Node2D
var _viewport : Viewport
var _viewport_texture_rect : TextureRect
var _viewport_camera : Camera2D

var _local_to_viewport : Transform2D
var _viewport_to_local : Transform2D
var _texture_to_viewport : Transform2D
var _viewport_to_texture : Transform2D

var _last_viewport_transform : Transform2D

# local_node : node2d inside viewport (such as a tilemap) that needs the mouse's position
# viewport_texture_rect : the TextureRect that the viewport is projecting to
func _init(local_node : Node2D, viewport_texture_rect : TextureRect) -> void:
	_viewport_texture_rect = viewport_texture_rect
	_local_node = local_node
	_viewport = _local_node.get_viewport()
	
	_update_calculations()


func _is_valid() -> bool:
	var nodes_valid = is_instance_valid(_local_node) && is_instance_valid(_viewport) && is_instance_valid(_viewport_texture_rect)
	if !nodes_valid:
		printerr("Attempting to get local mouse position using invalid nodes")
		return false
	return true



func get_global_mouse_position() -> Vector2:
	return _viewport.owner.get_global_mouse_position()


func get_local_mouse_position() -> Vector2:
	_update_calculations()
	var texture_rect_mouse_position = _viewport_texture_rect.get_local_mouse_position()
	var viewport_mouse_position = _texture_to_viewport * texture_rect_mouse_position
	var local_mouse_position = _viewport_to_local * viewport_mouse_position
	return local_mouse_position


func convert_local_to_global_position(local_pos : Vector2) -> Vector2:
	_update_calculations()
	var viewport_pos = _local_to_viewport * local_pos
	var texture_pos = _viewport_to_texture * viewport_pos
	return texture_pos


func convert_global_to_local_position(global_pos : Vector2) -> Vector2:
	_update_calculations()
	var viewport_pos = _texture_to_viewport * global_pos
	var local_pos = _viewport_to_local * viewport_pos
	return local_pos


func _update_calculations() -> void:
	if !_is_valid():
		return
	
	# avoid recalculating everything if viewport has not changed (resized or camera moved)
	if _last_viewport_transform == _viewport.canvas_transform:
		return

	_last_viewport_transform = _viewport.canvas_transform
	
#	print("viewport: %s" % _viewport)
#	print("text_rect: %s" % _viewport_texture_rect)
	
	_local_to_viewport = _local_node.get_viewport_transform() * _viewport.owner.get_global_transform()
	_viewport_to_local = _local_to_viewport.affine_inverse()
	_texture_to_viewport = Transform2D()
	_texture_to_viewport.x *= _viewport.size.x/_viewport_texture_rect.rect_size.x
	_texture_to_viewport.y *= _viewport.size.y/_viewport_texture_rect.rect_size.y
	_viewport_to_texture = _texture_to_viewport.affine_inverse()
