extends Area2D
class_name HurtBox

@export var damage : int = 1


func _ready():
	area_entered.connect(area_entered_)
	
func area_entered_(a : Area2D):
	if a is HitBox:
		a.take_damage(self)
