extends Container

onready var titleLabel : Label = $"%TitleLabel"
onready var textLabel : RichTextLabel = $"%TextLabel"

onready var scrollContainer : ScrollContainer = $"%ScrollContainer"
onready var vScroll = scrollContainer.get_v_scrollbar()


var text := "" setget set_text
func set_text(value : String) -> void:
	text = value.replace("[b]", "[color=#f4b41b]").replace("[/b]", "[/color]")
	textLabel.bbcode_text = text
	textLabel.bbcode_enabled = true

var title := "" setget set_title
func set_title(value : String) -> void:
	title = value
	titleLabel.text = value


func _ready() -> void:
	vScroll.theme_type_variation = "minimalscrollbar"
	

func display_panel(title_value : String, text_value : String) -> void:
	self.title = title_value
	self.text = text_value
	vScroll.value = 0
	show()



func _on_CloseButton_pressed() -> void:
	hide()
