extends CanvasLayer

var hearts : Array[HeartGUI] = []

func _ready() -> void:
	#look at all the hearts
	for child in $Control/HFlowContainer.get_children():
		if child is HeartGUI:
			#throw em in the array
			hearts.append(child)
			#turn em off
			child.visible = false

func update_hp(_hp: int, _max_hp: int) -> void:
	update_max_hp(_max_hp)
	for i in _max_hp:
		update_heart(i, _hp)
		
func update_heart(_index : int, _hp : int) -> void:
	var _value : int = clampi(_hp - _index * 2, 0, 2)
	hearts[_index].value = _value
	
func update_max_hp(_max_hp : int) -> void:
	#turn the hearts into half hearts
	var heart_count : int = roundi(_max_hp * 0.5)
	#go through each heart. If heart count says it should be on, turn it on
	for i in hearts.size():
		if i < heart_count:
			hearts[i].visible = true
		else:
			hearts[i].visible = false
