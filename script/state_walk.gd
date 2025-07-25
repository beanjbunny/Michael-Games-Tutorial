extends State
class_name State_Walk

@export var move_speed : float = 100.0
@onready var idle: State = $"../Idle"
@onready var attack: State = $"../Attack"

func enter() -> void:
	player.update_animation("walk")
	
func exit() -> void:
	pass

func process(delta: float) -> State:
	if player.direction == Vector2.ZERO:
		return idle
		print("oh laud she idlin")
	player.velocity = player.direction * move_speed
	if player.set_direction():
		player.update_animation("walk")
	return null
	
func physics(_delta : float) -> State:
	return null
	
func handle_input(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	return null
