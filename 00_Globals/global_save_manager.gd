extends Node
#global_save_manager.gd
const SAVE_PATH = "user://"

signal game_loaded
signal game_saved

var current_save : Dictionary = {
	scene_path = "",
	player = {
		hp = 1,
		max_hp = 1,
		pos_x = 0,
		pos_y = 0
	},
	items = [],
	persistence = [],
	quests = []
}

func update_player_data():
	var p: Player = GlobalPlayerManager.player
	current_save.player.hp = p.hp
	current_save.player.max_hp = p.max_hp
	current_save.player.pos_x = p.global_position.x
	current_save.player.pos_y = p.global_position.y

func save_game() -> void:
	update_player_data()
	update_scene_path()
	var file := FileAccess.open(SAVE_PATH + "save.sav", FileAccess.WRITE)
	var save_json = JSON.stringify(current_save)
	file.store_line(save_json)
	game_saved.emit()
	
func load_game():
	var file := FileAccess.open(SAVE_PATH + "save.sav", FileAccess.READ)
	var json := JSON.new()
	json.parse(file.get_line())
	var save_dict := json.get_data() as Dictionary
	current_save = save_dict
	#His also takes in Vector2.ZERO as a final argument. His is also busted.
	LevelManager.load_new_level(current_save.scene_path, "")
	await LevelManager.level_load_started
	GlobalPlayerManager.set_player_position(Vector2(current_save.player.pos_x, current_save.player.pos_y))
	GlobalPlayerManager.set_health(current_save.player.hp, current_save.player.max_hp)
	await LevelManager.level_loaded
	game_loaded.emit()
	
func update_scene_path():
	var p : String = ""
	for c in get_tree().root.get_children():
		if c is Level:
			p = c.scene_file_path
	current_save.scene_path = p
