extends Node


func load_file_into_array(filepath : String) -> Array:
	var lines := []
	var f = File.new()
	f.open(filepath, File.READ)
	var index = 1
	while not f.eof_reached(): # iterate through all lines until the end of file is reached
		lines.append(f.get_line())
	f.close()
	return lines


func load_files_from_directory(path) -> Dictionary:
	var d := {}
	var files = get_files(path)
	for file_name in files:
		var file_path = path + "/" + file_name
		var file_id = file_name.rsplit('.')[0]
		d[file_id] = load(file_path)
	return d


func get_files(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin(true)

	var file = dir.get_next()
	while file != '':
		files += [file]
		file = dir.get_next()

	return files


func is_filepath(value : String) -> bool:
	if value.begins_with("res://"):
		return true
	return false

func filepath_to_filename(filepath : String) -> String:
	if !filepath:
		return filepath
#	print("filepath: %s" % filepath)
#	print("-> %s" % filepath.rsplit('/', true, 1)[1])
#	print("-> %s" % filepath.rsplit('/')[1].rsplit('.')[0])
	return filepath.rsplit('/', true, 1)[1].rsplit('.', true, 1)[0]







func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	return input_vector


func event_is_left_click(event):
	return event is InputEventMouseButton && event.is_pressed() && event.button_index == BUTTON_LEFT

func event_is_right_click(event):
	return event is InputEventMouseButton && event.is_pressed() && event.button_index == BUTTON_RIGHT


func event_is_mouse_move(event):
	return event is InputEventMouseMotion


## Returns first node in group "group_name"
func get_node_by_group(group_name : String):
	var nodes = get_tree().get_nodes_in_group(group_name)
	if nodes.size() == 0:
		print("Warning: get_node_by_group() found no nodes with group_name=%s" % group_name)
		return null
	return nodes[0]


func clear_children(node : Node):
	for child in node.get_children():
		child.queue_free()
		

func change_node_parent(node : Node, to_parent : Node) -> void:
	var parent = node.get_parent()
	parent.remove_child(node)
	to_parent.add_child(node)
	
	

func roll_dice(sides = 6, quantity = 1) -> int:
	var result := 0
	
	var random = RandomNumberGenerator.new()
	random.randomize()
	
	for i in quantity:
		var roll = random.randi_range(1, sides)
		print("roll = %s" % roll)
		result += roll	
	
	return result
	







