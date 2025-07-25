extends CharacterBody2D
class_name Player

var cardinal_direction : Vector2 = Vector2.DOWN
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
var direction : Vector2 = Vector2.ZERO
@onready var state_machine: PlayerStateMachine = $StateMachine
signal direction_changed(new_direction : Vector2)
var new_dir
const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
signal player_damaged(hurt_box : HurtBox)
var invulnerable : bool = false
var hp : int = 6
@onready var hit_box : HitBox = $HitBox
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer
var max_hp : int = 6


func _ready():
	hit_box.damaged.connect(_take_damage)
	state_machine.initialize(self)
	GlobalPlayerManager.player = self
	update_hp(99)
	print("player instantiated")

func _process(delta: float) -> void:
	#direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	#direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	
func _physics_process(delta: float) -> void:
	move_and_slide()

func update_animation(state) -> void:
	animation_player.play(state + "_" + anim_direction())
	
func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

func set_direction() -> bool:
	var new_dir : Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
	var direction_id : int = int(round(direction + cardinal_direction * 0.1).angle()/TAU*DIR_4.size())
	new_dir = DIR_4[direction_id]
	if new_dir == cardinal_direction:
		return false
	cardinal_direction = new_dir
	direction_changed.emit(new_dir)
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true

func update_hp(delta : int) -> void:
	hp = clampi(hp+delta, 0, max_hp)
	PlayerHud.update_hp(hp, max_hp)

func _take_damage(hurt_box : HurtBox) -> void:
	if invulnerable == true: return
	update_hp(-hurt_box.damage)
	if hp > 0:
		player_damaged.emit(hurt_box)
	else:
		#this is a fake player death for now
		player_damaged.emit(hurt_box)
		update_hp(99)
		
func make_invulnerable(_duration : float = 1.0) -> void:
	invulnerable = true
	hit_box.monitoring = false
	await get_tree().create_timer(_duration).timeout
	invulnerable = false
	hit_box.monitoring = true
