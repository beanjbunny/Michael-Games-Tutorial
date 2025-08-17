extends Node2D
class_name Plant

func take_damage(_damage : HurtBox):
	queue_free()
	
func _ready():
	$HitBox.damaged.connect(take_damage)
