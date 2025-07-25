extends EnemyState
class_name EnemyStateStun

@export var anim_name : String = "stun"
@export_category("AI")
#@export var after_idle_state : EnemyState
@export var knockback_speed : float = 200.0
@export var state_animation_duration : float = 0.7
@export var next_state : EnemyState
@export var decelerate_speed : float = 10.0
var _direction : Vector2 = Vector2.DOWN
var _animation_finished : bool = false
var _damage_position : Vector2

func init() -> void:
	enemy.enemy_damaged.connect(_on_enemy_damaged)
	
func enter()->void:
	enemy.invulnerable = true
	_animation_finished = false
	_direction = enemy.global_position.direction_to(_damage_position)
	enemy.set_direction(_direction)
	enemy.velocity = _direction * -knockback_speed
	enemy.update_animation(anim_name)
	enemy.animation_player.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished(_a : String) -> void:
	_animation_finished = true
	
func exit()->void:
	enemy.invulnerable = false
	enemy.animation_player.animation_finished.disconnect(_on_animation_finished)
	
func process(_delta: float) -> EnemyState:
	if _animation_finished == true:
		return next_state
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null
	
func _on_enemy_damaged(hurt_box : HurtBox):
	_damage_position = hurt_box.global_position
	state_machine.change_state(self)
	
func physics(_delta : float) -> EnemyState:
	return null
