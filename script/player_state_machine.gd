extends Node
class_name PlayerStateMachine

var states : Array[State]
var prev_state : State
var current_state : State

func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED
	
func change_state(new_state : State) -> void:
	if new_state == null || new_state == current_state:
		return
	if current_state:
		current_state.exit()
	prev_state = current_state
	current_state = new_state
	current_state.enter()
	
func initialize(_player : Player) -> void:
	states = []
	for c in get_children():
		if c is State:
			states.append(c)
	if states.size() == 0: return
	states[0].player = _player
	states[0].state_machine = self
	for state in states:
		state.init()
	change_state(states[0])
	process_mode = Node.PROCESS_MODE_INHERIT

func _process(delta):
	change_state(current_state.process(delta))
	
func _physics_process(delta: float) -> void:
	change_state(current_state.physics(delta))
	
func _unhandled_input(event: InputEvent) -> void:
	change_state(current_state.handle_input(event))
