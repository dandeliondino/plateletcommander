extends PanelContainer

# Call setup() with params in this format:
#var params = {
#		"alignment": Game.ALIGN_VERTICAL,
#		"title": "Travel to %s" % name_text,
#		"description": "Choose a route:",
#		"options": [
#			route_options_text[route_options.WALK_OVERLAND],
#			route_options_text[route_options.WALK_COAST],
#			route_options_text[route_options.ROWBOAT],
#			route_options_text[route_options.CANCEL],
#		]
#	}

signal option_chosen(value)

var current_button_container : Container

onready var titleLabel := $"%TitleLabel"
onready var descriptionLabel := $"%DescriptionLabel"
onready var verticalButtonContainer : Container = $"%VerticalButtonContainer"
onready var horizontalButtonContainer : Container = $"%HorizontalButtonContainer"

func _ready():
	Utils.clear_children(verticalButtonContainer)
	Utils.clear_children(horizontalButtonContainer)


func setup(params : Dictionary):
	update_button_container(params)
	titleLabel.text = params.get("title", "Make a choice")
	descriptionLabel.text = params.get("description", "")
	if !descriptionLabel.text:
		descriptionLabel.visible = false
	
	assert(params.has("options"), "Confirmation box called with no options")
	assert(params["options"].size() > 0, "Confirmation box called with no options")

	var options : Array = params["options"]
	for i in options.size():
		add_button(i, options[i])
	
	current_button_container.visible = true
	rect_size = rect_min_size
	get_parent().emit_signal("size_changed")


func add_button(index : int, text : String):
	var button := Button.new()
	button.text = text
	current_button_container.add_child(button)
	button.connect("pressed", self, "_on_button_pressed", [index])
	
	
func update_button_container(params : Dictionary):
	var alignment = params.get("alignment", Game.ALIGN_HORIZONTAL)
	if alignment == Game.ALIGN_VERTICAL:
		current_button_container = verticalButtonContainer
		verticalButtonContainer.visible = true
		horizontalButtonContainer.visible = false
	else:
		current_button_container = horizontalButtonContainer
		horizontalButtonContainer.visible = true
		verticalButtonContainer.visible = false


func _on_button_pressed(index : int):
	emit_signal("option_chosen", index)






