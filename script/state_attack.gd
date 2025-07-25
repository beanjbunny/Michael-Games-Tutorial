extends State
class_name State_Attack

@onready var walk: State = $"../Walk"
var attacking : bool = false
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var idle: State_Idle = $"../Idle"
@onready var attack_anim: AnimationPlayer = $"../../Sprite2D/AttackEffectSprite/AnimationPlayer"
@export var attack_sound : AudioStream
@onready var audio: AudioStreamPlayer = $"../../Audio/AudioStreamPlayer2D"
@export_range(1, 20, 0.5) var decelerate_speed : float = 5
@onready var hurt_box: HurtBox = %AttackHurtBox

func enter() -> void:
	player.update_animation("attack")
	attack_anim.play("attack_" + player.anim_direction())
	attacking = true
	animation_player.animation_finished.connect(end_attack)
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()
	await get_tree().create_timer(0.075).timeout
	hurt_box.monitoring = true
	
func exit() -> void:
	animation_player.animation_finished.disconnect(end_attack)
	attacking = false
	hurt_box.monitoring = false
	pass

func process(_delta: float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null
	
func physics(_delta : float) -> State:
	return null
	
func handle_input(_event: InputEvent) -> State:
	return null

func end_attack(new_anim_name : String):
	attacking = false
