extends Line2D

var tween : SceneTreeTween

func _ready() -> void:
	Game.connection_line = self
	


func show_as_valid(from_node : Node2D, to_node : Node2D) -> void:
	show_with_color(from_node, to_node, Color.green)

func show_as_invalid(from_node : Node2D, to_node : Node2D) -> void:
	show_with_color(from_node, to_node, Color.red)

func show_with_color(from_node : Node2D, to_node : Node2D, color : Color) -> void:
	default_color = color
	points = [from_node.global_position, to_node.global_position]
	show()
	fade_away()

func fade_away() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_interval(1.0)
	tween.tween_callback(self, "hide")
