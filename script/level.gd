extends Node2D
class_name Level

func _ready() -> void:
	self.y_sort_enabled = true
	GlobalPlayerManager.set_as_parent(self)
	LevelManager.level_load_started.connect(_free_level)

func _free_level() ->void:
	GlobalPlayerManager.unparent_player(self)
	queue_free()
