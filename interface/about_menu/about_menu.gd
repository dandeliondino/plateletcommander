extends PanelContainer

export(String, FILE) var readme_path

onready var creditContainer : Container = $"%CreditContainer"

var regex = RegEx.new()



func _ready() -> void:
	regex.compile("(\\[([^\\]]*)\\]\\(([^\\(\\)]*)\\))")
	
	var readme_data := Utils.load_file_into_array(readme_path)
	var credit_lines := []
	var credit_section := false
	for line in readme_data:
		if "## Credits" in line:
			credit_section = true
			continue
		elif "## " in line:
			credit_section = false
	
		if credit_section:
			if !line.empty():
				credit_lines.append(line.trim_prefix("- "))
	
	for line in credit_lines:
		var label := Label.new()
		label.autowrap = true
		
		var s = regex.sub(line, "$2 ($3)", true)
		
		label.text = s
		creditContainer.add_child(label)







func _on_CloseButton_pressed() -> void:
	Events.emit_signal("game_state_exit_requested")
