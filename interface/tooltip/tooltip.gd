extends Container

onready var label : RichTextLabel = $"%TooltipLabel"
onready var moreInfoRect : TextureRect = $"%MoreInfoRect"

var max_width := 128
var string_size := 0


var text := "" setget set_text
func set_text(value : String) -> void:
	text = value.replace("[b]", "[color=#f4b41b]").replace("[/b]", "[/color]")
	label.bbcode_text = text
	label.bbcode_enabled = true
	var plain_string = value.replace("[b]", "").replace("[/b]", "")
	string_size = font.get_string_size(plain_string).x
#	print("string_size=%s" % string_size)
	_recalculate_size()

var more_info_path := "" setget set_more_info_path
func set_more_info_path(value : String) -> void:
	more_info_path = value
	if value:
		moreInfoRect.show()
	else:
		moreInfoRect.hide()
	_recalculate_size()

onready var font = label.get_font("normal_font")

func _ready() -> void:
	hide()
	moreInfoRect.hide()

func setup(text_value : String, more_info_path_value := "") -> void:
	self.text = text_value
	self.more_info_path = more_info_path_value

func show_at_position(pos : Vector2) -> void:
	rect_global_position = pos
	show()

func _recalculate_size() -> void:
	var width = string_size + 16
	if more_info_path:
		width += 22
	rect_min_size.x = min(max_width, width)
	
	
	

