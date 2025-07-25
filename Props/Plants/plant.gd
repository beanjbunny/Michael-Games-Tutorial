extends Node2D
class_name Plant

func take_damage(_damage : int):
	queue_free()
	
func _ready():
	$HitBox.damaged.connect(take_damage)
