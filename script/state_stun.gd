extends State
class_name State_Stun

@onready var idle: State = $"../Idle"
@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0
@export var invulnerable_duration : float = 1.0
var direction : Vector2
var hurt_box : HurtBox
var next_state : State = null

func enter() -> void:
	player.animation_player.animation_finished.connect(_animation_finished)
	direction = player.global_position.direction_to(hurt_box.global_position)
	player.velocity = direction * -knockback_speed
	player.set_direction()
	player.update_animation("stun")
	player.make_invulnerable(invulnerable_duration)
	player.effect_animation_player.play("damaged")
	
func _animation_finished(_a: String) ->void:
	next_state = idle
	#next time process runs it will return idle
	
func exit() -> void:
	next_state = null
	player.animation_player.animation_finished.disconnect(_animation_finished)

func init() -> void:
	player.player_damaged.connect(_player_damaged)
	
func _player_damaged(_hurt_box : HurtBox) -> void:
	hurt_box = _hurt_box
	state_machine.change_state(self)

func process(_delta: float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	return next_state
	
func physics(_delta : float) -> State:
	return null
	
func handle_input(_event: InputEvent) -> State:
	return null
