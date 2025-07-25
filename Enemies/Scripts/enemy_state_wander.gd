extends EnemyState
class_name EnemyStateWander

@export var anim_name : String = "walk"
@export_category("AI")
#@export var after_idle_state : EnemyState
var _timer : float = 0.0
@export var wander_speed : float = 20.0
@export var state_animation_duration : float = 0.7
@export var state_cycles_min : int = 1
@export var state_cycles_max : int = 3
@export var next_state : EnemyState
var _direction : Vector2 = Vector2.DOWN

func init() -> void:
	pass
	
func enter()->void:
	_timer = randi_range(state_cycles_min, state_cycles_max) * state_animation_duration
	var rand = randi_range(0, 3)
	_direction = enemy.DIR_4[rand]
	enemy.velocity = _direction * wander_speed
	enemy.set_direction(_direction)
	enemy.update_animation(anim_name)
	
func exit()->void:
	pass
	
func process(_delta: float) -> EnemyState:
	_timer -= _delta
	if _timer <= 0:
		return next_state
	return null
	
func physics(_delta : float) -> EnemyState:
	return null
