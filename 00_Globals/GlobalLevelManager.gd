extends Node

var current_tilemap_bounds : Array[Vector2]
signal TileMapBoundsChanged(bounds : Array[Vector2])
signal level_load_started
signal level_loaded
var target_transition : String
var position_offset : Vector2

func _ready() -> void:
	await get_tree().process_frame
	level_loaded.emit()

func change_tilemap_bounds(bounds : Array[Vector2]):
	current_tilemap_bounds = bounds
	TileMapBoundsChanged.emit(bounds)

func load_new_level(
	level_path : String,
	_target_transition : String,
	_position_offset : Vector2
) -> void:
	get_tree().paused = true
	target_transition = _target_transition
	position_offset = _position_offset
	await get_tree().process_frame
	level_load_started.emit()
	await get_tree().process_frame
	get_tree().change_scene_to_file(level_path)
	await get_tree().process_frame
	get_tree().paused = false
	await get_tree().process_frame
	level_loaded.emit()
