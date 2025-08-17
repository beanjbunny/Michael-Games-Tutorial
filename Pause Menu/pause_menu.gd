extends CanvasLayer
#pause_menu.gd

var is_paused : bool = false
@onready var save_button: Button = $Control/CenterContainer/HBoxContainer/VBoxContainer/HBoxContainer/SaveButton
@onready var load_button: Button = $Control/CenterContainer/HBoxContainer/VBoxContainer/HBoxContainer/LoadButton
@onready var item_description: Label = $Control/CenterContainer/HBoxContainer/VBoxContainer/ItemDescription
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


signal shown
signal hidden

func _ready() -> void:
	hide_pause_menu()
	save_button.pressed.connect(_on_save_pressed)
	load_button.pressed.connect(_on_load_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if is_paused == false:
			show_pause_menu()
		elif is_paused == true:
			print("HEY")
			hide_pause_menu()
		get_viewport().set_input_as_handled()
		
func show_pause_menu():
	get_tree().paused = true
	visible = true
	is_paused = true
	#save_button.grab_focus()
	shown.emit()
	
func hide_pause_menu():
	get_tree().paused = false
	visible = false
	is_paused = false
	hidden.emit()
	
func _on_save_pressed() ->void:
	if is_paused == false: return
	GlobalSaveManager.save_game()
	hide_pause_menu()

func _on_load_pressed():
	if is_paused == false: return
	GlobalSaveManager.load_game()
	await LevelManager.level_load_started
	hide_pause_menu()
	
func update_item_description(new_text : String):
	item_description.text = new_text
	
func play_audio(audio : AudioStream):
	audio_stream_player.stream = audio
	audio_stream_player.play()
