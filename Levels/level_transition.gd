@tool
extends Area2D

@export_file("*.tscn") var level
@export var target_spawner: String = "default"

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

#HIS IS DIFFERENT
#This one you got off discord. His is busted, yours works, don't touch it

func _ready() -> void:
	if collision_shape_2d == null:
		collision_shape_2d = CollisionShape2D.new()
		collision_shape_2d.name = "CollisionShape2D"
		add_child(collision_shape_2d)
		collision_shape_2d.owner = get_tree().edited_scene_root if Engine.is_editor_hint() else self

	if collision_shape_2d.shape == null:
		collision_shape_2d.shape = RectangleShape2D.new()
		collision_shape_2d.shape.size = Vector2(32, 32)
	if Engine.is_editor_hint():
		print("LevelTransition ", name, ": Created default RectangleShape2D with size (32, 32). Adjust in inspector.")

	if Engine.is_editor_hint():
		return

	monitoring = true
	body_entered.connect(_player_entered)

func _player_entered(body: Node2D) -> void:
	if not body is Player:
		return 
	if level == "":
		push_error("Level path not set for transition: ", name)
		return
	LevelManager.load_new_level(level, target_spawner)


#class_name LevelTransition
#
#enum SIDE { LEFT, RIGHT, TOP, BOTTOM }
#
#@export_file("*.tscn") var level
#@export var target_transition_area : String = "LevelTransition"
#@export_category("Collision Area Settings")
#@export var snap_to_grid : bool = false:
	#set (_v):
		#snap_to_grid = _v
		#_snap_to_grid()
#@export var side : SIDE = SIDE.LEFT : 
	#set(_v):
		#side = _v
		#_update_area()
#@onready var collision_shape : CollisionShape2D = $CollisionShape2D
#@export_range(1, 12, 1, "or_greater") var size : int = 2 :
	#set(_v):
		#size = _v
		#_update_area()
#
#func _ready():
	#_update_area()
	#if Engine.is_editor_hint():
		##Returns true if the script is currently running inside the editor, otherwise returns false
		##Anyway, dop out if you're in the game
		#return
	#monitoring = false
	#_place_player()
	#await LevelManager.level_loaded
	#monitoring = true
	#body_entered.connect(_player_entered)
	#
#func _player_entered(_p : Node2D) -> void:
	#LevelManager.load_new_level(level, target_transition_area, get_offset())
#
#func _update_area() -> void:
	#var new_rect : Vector2 = Vector2(32, 32)
	#var new_position : Vector2 = Vector2.ZERO
	#if side == SIDE.TOP:
		#new_rect.x *= size
		#new_position.y -= 16
	#elif side == SIDE.BOTTOM:
		#new_rect.x *= size
		#new_position.y += 16
	#elif side == SIDE.LEFT:
		#new_rect.y *= size
		#new_position.x -=16
	#elif side == SIDE.RIGHT:
		#new_rect.y *= size
		#new_position.x += 16
	#
	#if collision_shape == null:
		#collision_shape = get_node("CollisionShape2D")
	#collision_shape.shape.size = new_rect
	#collision_shape.position = new_position
#
#func _snap_to_grid() -> void:
	#position.x = round(position.x / 16) * 16
	#position.y = round(position.y / 16) * 16
#
#func _place_player() -> void:
	#if name != LevelManager.target_transition: return
	#GlobalPlayerManager.set_player_position(global_position + LevelManager.position_offset)
#
#func get_offset() -> Vector2:
	#var offset : Vector2 = Vector2.ZERO
	#var player_pos = GlobalPlayerManager.player.global_position
	#if side == SIDE.LEFT or side == SIDE.RIGHT:
		#offset.y = player_pos.y - global_position.y
		#offset.x = 16
		#if side == SIDE.LEFT:
			#offset.x *= -1
	#else:
		#offset.x = player_pos.x - global_position.x
		#offset.y = 16
		#if side == SIDE.TOP:
			#offset.y *= -1
	#return offset
			#
