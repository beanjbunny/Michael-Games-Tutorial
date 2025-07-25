extends Node
class_name State

static var player : Player
static var state_machine : PlayerStateMachine

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func init() -> void:
	pass

func process(delta: float) -> State:
	return null
	
func physics(_delta : float) -> State:
	return null
	
func handle_input(_event: InputEvent) -> State:
	return null
