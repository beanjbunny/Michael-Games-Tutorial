extends Resource
class_name SlotData

@export var item_data : ItemData
@export var quantity : int = 0 : set = set_quantity

func set_quantity(value : int) -> void:
	quantity = value
	if quantity < 1:
		print("set quantity print statement prints")
		emit_changed()
		#we hit 0
