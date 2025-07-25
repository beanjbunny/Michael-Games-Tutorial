extends Control
class_name HeartGUI

@onready var sprite: Sprite2D = $Sprite2D

var value : int = 2:
	set(_value):
		value = _value
		update_sprite(value)
		
func update_sprite(value) -> void:
	sprite.frame = value
