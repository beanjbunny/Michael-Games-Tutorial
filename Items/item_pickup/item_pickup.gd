@tool
class_name ItemPickup
extends CharacterBody2D

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var item_data : ItemData : set = set_item_data

func set_item_data(value : ItemData) -> void:
	item_data = value
	_update_texture()
	
func _ready():
	_update_texture()
	if Engine.is_editor_hint():
		return
	area_2d.body_entered.connect(_on_body_entered)
	
func _on_body_entered(b) -> void:
	print(b)
	if b is Player:
		print("is_player check completed")
		if item_data:
			print("is item check completed")
			if GlobalPlayerManager.INVENTORY_DATA.add_item(item_data) == true:
				print("is global_manager check completed")
				item_picked_up()
				
func item_picked_up() -> void:
	area_2d.body_entered.disconnect(_on_body_entered)
	audio_stream_player_2d.play()
	visible = false
	await audio_stream_player_2d.finished
	queue_free()
	
func _update_texture() -> void:
	if item_data and sprite_2d:
		sprite_2d.texture = item_data.texture
		
func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
	velocity -= velocity * delta * 4
