class_name AStarTileMap
extends Node



#Interfaces with Astar for lower-level pathfinding. Only accessed by LevelMap. Communicates with LevelMap in cells vector2s, and with astar in ids.
#
#    navpath -> array of cell vector2s
#
#    get_cell_or_closest(target, from, exclude_target, max_distance)
#
#    add points
#    connect points
#    enable/disable points
#    get cell id
#
#

var neighbor_vectors = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

var astar : AStar2D
var nav_cells : Array
var map_limits : Rect2


func _init(cells : Array, rect : Rect2) -> void:
	nav_cells = cells
	map_limits = rect
	astar = AStar2D.new()
	_add_points()
	_connect_points()


func get_nav_path(start_cell, end_cell) -> PoolVector2Array:
	var path : PoolVector2Array = astar.get_point_path(_get_id(start_cell), _get_id(end_cell))
	return path

func disable_cell(cell : Vector2) -> void:
	astar.set_point_disabled(_get_id(cell), true)

func enable_cell(cell : Vector2) -> void:
	astar.set_point_disabled(_get_id(cell), false)

func _add_points() -> void:
	astar.clear()
	for cell in nav_cells:
		var point = _get_id(cell)
		astar.add_point(point, cell)


func _connect_points() -> void:
	for cell in nav_cells:
		var cell_id = _get_id(cell)
		var neighbors := get_cell_neighbors(cell)
		for neighbor in neighbors:
			astar.connect_points(cell_id, _get_id(neighbor), false)


func get_cell_neighbors(cell : Vector2) -> PoolVector2Array:
	var neighbors := PoolVector2Array()
	for v in neighbor_vectors:
		var neighbor = cell + v
		if nav_cells.has(neighbor):
			neighbors.append(neighbor)
	return neighbors





func _get_id(cell_pos : Vector2) -> int:
	var adjusted_cell_pos = cell_pos - map_limits.position
	var id = adjusted_cell_pos.y * map_limits.size.x + adjusted_cell_pos.x
	return id





