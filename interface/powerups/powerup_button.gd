extends Button

var mysterious_texture := preload("res://assets/sprites/question_mark.png")

export(Game.POWERUP) var powerup_id : int
export(Texture) var powerup_texture : Texture
export(String) var ink_path : String


# COUNT
var count : int setget set_count, get_count
func set_count(value : int) -> void:
	count = value # so don't make mistake of referencing it directly in this script
	Game.inventory[powerup_id] = value
	
	if value > 0:
		self.received_first_item = true
	update_count_label()


func get_count() -> int:
	return Game.inventory[powerup_id]


# RECEIVED_FIRST_ITEM
var received_first_item := false setget set_received_first_item
func set_received_first_item(value : bool) -> void:
	if value == received_first_item:
		return
	received_first_item = value
	match value:
		true:
			icon = powerup_texture
			countLabel.show()
		false:
			icon = mysterious_texture
			countLabel.hide()
			
	






# ONREADY
onready var countLabel := $"%CountLabel"

func _ready() -> void:
	Events.connect("level_loading", self, "_on_Events_level_loading")
	Events.connect("powerup_added", self, "_on_Events_powerup_added")
	Events.connect("powerup_used", self, "_on_Events_powerup_used")
	countLabel.hide()
	reset()


# PUBLIC FUNCTIONS
func update_count_label() -> void:
	countLabel.text = str(self.count)

func reset() -> void:
	self.count = 0
	self.received_first_item = false


func get_drag_data(position: Vector2):
	if self.count <= 0:
		return null
	
	var textrect = TextureRect.new()
	textrect.texture = powerup_texture
	set_drag_preview(textrect)
	
	return {
		"drop_type": Game.DROP_TYPES.POWERUP,
		"powerup_id": powerup_id,
	}


# PRIVATE FUNCTIONS
func show_tooltip() -> void:
	var tooltip_text := "???"
	var more_info_path := ""
	
	if received_first_item:
		tooltip_text = Game.ink_manager.get_text(ink_path + ".tooltip")
		tooltip_text = tooltip_text.strip_edges()
		more_info_path = ink_path
		
	Game.tooltip.show_tooltip(self, tooltip_text, more_info_path)


# SIGNALS
func _on_Events_level_loading() -> void:
	reset()

func _on_Events_powerup_added(id : int) -> void:
	if id == powerup_id:
		self.count = self.count + 1


func _on_Events_powerup_used(id : int) -> void:
	if id == powerup_id:
		self.count = self.count - 1


func _on_PowerupButton_mouse_entered() -> void:
	show_tooltip()


func _on_PowerupButton_mouse_exited() -> void:
	Game.tooltip.hide_tooltip(self)




func _on_PowerupButton_gui_input(event: InputEvent) -> void:
	if Utils.event_is_right_click(event) && ink_path && received_first_item:
		Events.emit_signal("more_info_panel_requested", ink_path)
