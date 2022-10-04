extends CanvasLayer

var fade_to_game_color
var fade_to_black_color

onready var blackRect := $"%BlackRect"


func _ready():
	fade_to_black_color = blackRect.modulate
	fade_to_game_color = fade_to_black_color
	fade_to_game_color.a = 0.0
	
	Events.connect("fade_to_black_requested", self, "_on_Events_fade_to_black_requested")
	Events.connect("fade_to_game_requested", self, "_on_Events_fade_to_game_requested")
	reset()


func reset():
	visible = false
	blackRect.modulate = fade_to_game_color


func fade_to_black():
	visible = true
	var tween = create_tween()
	tween.tween_property(blackRect, "modulate", fade_to_black_color, Game.settings.fade_to_black_time)
	yield(tween, "finished")
	Game.faded_to_black = true
	Events.emit_signal("faded_to_black")


func fade_to_game():
	var tween = create_tween()
	tween.tween_property(blackRect, "modulate", fade_to_game_color, Game.settings.fade_to_game_time)
	yield(tween, "finished")
	visible = false
	Game.faded_to_black = false
	Events.emit_signal("faded_to_game")


func _on_Events_fade_to_black_requested():
	fade_to_black()


func _on_Events_fade_to_game_requested():
	fade_to_game()
