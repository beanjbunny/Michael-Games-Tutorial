extends Node2D
class_name PlayerInteractionsHost
@onready var player: Player = $".."

func _ready():
	player.direction_changed.connect(update_direction)

func update_direction(new_direction : Vector2):
	match new_direction:
		Vector2.DOWN:
			rotation_degrees = 0
		Vector2.UP:
			rotation_degrees = 180
		Vector2.LEFT:
			rotation_degrees = 90
		Vector2.RIGHT:
			rotation_degrees = -90
		_:
			rotation_degrees = 0
