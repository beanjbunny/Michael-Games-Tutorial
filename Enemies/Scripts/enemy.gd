extends CharacterBody2D
class_name Enemy

signal direction_changed(new_direction : Vector2)
signal enemy_damaged(hurt_box : HurtBox)
const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
@export var hp : int = 3
var cardinal_direction : Vector2 = Vector2.DOWN
var player : Player
var invulnerable : bool = false
@onready var animation_player = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
var direction : Vector2 = Vector2.ZERO
@onready var state_machine : EnemyStateMachine = $EnemyStateMachine
@onready var hit_box: HitBox = $HitBox
signal enemy_destroyed(hurt_box : HurtBox)


func _ready():
	state_machine.initialize(self)
	player = GlobalPlayerManager.player
	hit_box.damaged.connect(_take_damage)
	
func _take_damage(hurt_box : HurtBox) -> void:
	if invulnerable == true: return
	hp -= hurt_box.damage
	if hp > 0:
		enemy_damaged.emit(hurt_box)
	else:
		enemy_destroyed.emit(hurt_box)

func _physics_process(_delta: float) -> void:
	move_and_slide()
	
func set_direction(_new_direction : Vector2) -> bool:
	#var new_dir : Vector2 = cardinal_direction
	direction = _new_direction
	if direction == Vector2.ZERO:
		return false
	var direction_id : int = int(round(direction + cardinal_direction * 0.1).angle()/TAU*DIR_4.size())
	var new_dir = DIR_4[direction_id]
	if new_dir == cardinal_direction:
		return false
	cardinal_direction = new_dir
	direction_changed.emit(new_dir)
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true

func update_animation(state) -> void:
	animation_player.play(state + "_" + anim_direction())
	
func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
