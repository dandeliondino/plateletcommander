class_name NavMap
extends TileMap


var occupied_cells := {}


var neighbor_vectors := {
	Game.DIRECTION.LEFT: Vector2.LEFT,
	Game.DIRECTION.UP_LEFT: Vector2.UP + Vector2.LEFT,
	Game.DIRECTION.UP: Vector2.UP,
	Game.DIRECTION.UP_RIGHT: Vector2.UP + Vector2.RIGHT,
	Game.DIRECTION.RIGHT: Vector2.RIGHT,
	Game.DIRECTION.DOWN_RIGHT: Vector2.DOWN + Vector2.RIGHT,
	Game.DIRECTION.DOWN: Vector2.DOWN,
	Game.DIRECTION.DOWN_LEFT: Vector2.DOWN + Vector2.LEFT,
}


onready var NAV_TILE = tile_set.find_tile_by_name("nav")
onready var OCCUPIED_TILE = tile_set.find_tile_by_name("occupied")
onready var PATH_TILE = tile_set.find_tile_by_name("path")
onready var RBC_TARGET_TILE = tile_set.find_tile_by_name("blue")

onready var nav_cells := get_used_cells_by_id(NAV_TILE)
onready var astar_tilemap : AStarTileMap


func _ready():
	astar_tilemap = AStarTileMap.new(nav_cells, get_used_rect())
	if Game.settings.show_navmap:
		self.modulate.a = 0.5
		visible = true
	else:
		visible = false
		
	yield(owner, "ready") # entities may not appear if don't wait
	_update_occupied_cells()
	Events.connect("entity_cell_changed", self, "_on_Events_entity_cell_changed")
	
	
	


# PUBLIC METHODS

func get_cell_adjacent_to(target_cell : Vector2, start_cell := Game.INVALID_CELL) -> Vector2:
	var neighbors := astar_tilemap.get_cell_neighbors(target_cell)
	var neighbor_distances := []
	for cell in neighbors:
		if is_cell_occupied(cell):
			continue
		elif start_cell == Game.INVALID_CELL:
			return cell
		else:
			var distance = get_position_at_cell(start_cell).distance_to(get_position_at_cell(cell))
			neighbor_distances.append([cell, distance])
	
	if neighbor_distances.size() == 0:
		return Game.INVALID_CELL
	
	neighbor_distances.sort_custom(self, "_sort_by_distance")
	
	return neighbor_distances[0][0]





# Returns cell coordinates at node's origin
# node must be inside this viewport
func get_cell_at_node(node : Node2D) -> Vector2:
	return get_cell_at_position(node.global_position)


# Returns cell coordinates at position
# pos must be a global position inside this viewport
func get_cell_at_position(pos : Vector2) -> Vector2:
	var local_pos = to_local(pos)
	var cell = world_to_map(local_pos)
#	if !nav_cells.has(cell):
#		return Game.INVALID_CELL
	return cell	


func get_entity_at_cell(cell : Vector2):
	if occupied_cells.has(cell):
		return occupied_cells[cell]
	else:
		return null


func get_nav_path(start_cell : Vector2, end_cell : Vector2) -> PoolVector2Array:
	if not start_cell in nav_cells or not end_cell in nav_cells:
		return Game.INVALID_PATH
	return astar_tilemap.get_nav_path(start_cell, end_cell)


func get_nav_path_positions(start_cell : Vector2, end_cell : Vector2) -> PoolVector2Array:
	var path = get_nav_path(start_cell, end_cell)
	if path == Game.INVALID_PATH:
		return Game.INVALID_PATH
	
	var path_positions := PoolVector2Array()
	for cell in path:
		path_positions.append(get_position_at_cell(cell))
	return path_positions


func get_neighbor_direction(from_cell : Vector2, to_cell : Vector2) -> int:
	var v = to_cell - from_cell
	for neighbor_direction in neighbor_vectors.keys():
		if neighbor_vectors[neighbor_direction] == v:
			return neighbor_direction
	return Game.INVALID_NEIGHBOR


func get_neighbors(from_cell : Vector2, navigable_only := false) -> Array:
	var neighbors := []
	for direction in neighbor_vectors:
		var cell = get_neighbor_cell(from_cell, direction)
		if !navigable_only or is_cell_navigable(cell):
			neighbors.append(cell)	
	return neighbors


func get_neighbor_cell(from_cell : Vector2, direction : int) -> Vector2:
	var v = neighbor_vectors[direction]
	return from_cell + v


# Returns global position of cell center
func get_position_at_cell(cell : Vector2) -> Vector2:
	var top_left_pos := map_to_world(cell)
	var center_pos := top_left_pos + cell_size/2
	var global_pos := to_global(center_pos)
	return global_pos


func is_cell_interactable(cell : Vector2) -> bool:
	var entity = get_entity_at_cell(cell)
	return is_instance_valid(entity) && entity.is_interactable()


func is_cell_navigable(cell : Vector2) -> bool:
	if cell == Game.INVALID_CELL:
		return false
		
	return nav_cells.has(cell) && !is_cell_occupied(cell)


func is_cell_next_to(cell : Vector2, neighbor_cell : Vector2) -> bool:
#	var neighbors := astar_tilemap.get_cell_neighbors(cell)
#	return neighbors.has(neighbor_cell)
	var v := neighbor_cell - cell
	if v.x <= 1 && v.x >= -1 && v.y <= 1 && v.y >= -1:
		return true
	return false

func is_cell_occupied(cell : Vector2) -> bool:
	return occupied_cells.has(cell)





# PRIVATE FUNCTIONS
func _update_occupied_cells() -> void:
	occupied_cells = {}
	var entities = get_tree().get_nodes_in_group(Game.ENTITY_GROUP)
	for entity in entities:
		var cell = entity.cell
		occupied_cells[cell] = entity
	_update_nav_map()


func _update_occupied_cell(entity : Entity, from_cell : Vector2, to_cell : Vector2) -> void:
	_update_from_cell(entity, from_cell)
	_update_to_cell(entity, to_cell)
	
	
func _update_from_cell(entity : Entity, from_cell : Vector2) -> void:
	if from_cell == Game.INVALID_CELL or !occupied_cells.has(from_cell):
		return
	
	if occupied_cells[from_cell] != entity:
		Dprint.warning("Attempting to remove wrong entity from occupied cell")
		return
		
	occupied_cells.erase(from_cell)
	astar_tilemap.enable_cell(from_cell)
	set_cellv(from_cell, NAV_TILE)


func _update_to_cell(entity : Entity, to_cell : Vector2) -> void:
	if to_cell == Game.INVALID_CELL:
		return
		
	if occupied_cells.has(to_cell):
		Dprint.warning("To_cell already in occupied cells")
		# see if it fixes itself
		yield(get_tree().create_timer(1.0), "timeout")
		_update_occupied_cells()
		return
		
	occupied_cells[to_cell] = entity
	astar_tilemap.disable_cell(to_cell)
	set_cellv(to_cell, OCCUPIED_TILE)


func _update_nav_map() -> void:	
	for cell in nav_cells:
		if occupied_cells.has(cell):
			astar_tilemap.disable_cell(cell)
			set_cellv(cell, OCCUPIED_TILE)
		else:
			astar_tilemap.enable_cell(cell)
			set_cellv(cell, NAV_TILE)


func _sort_by_distance(a, b):
	return a[1] <= b[1]


# SIGNALS
func _on_Events_entity_cell_changed(entity : Entity, from_cell : Vector2, to_cell : Vector2) -> void:
	_update_occupied_cell(entity, from_cell, to_cell)





