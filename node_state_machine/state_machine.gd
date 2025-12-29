extends Node

class_name StateMachine

@export var initial_state: State
var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.STATE_TYPE] = child
			child.state_machine = self
	if initial_state:
		call_deferred("change_state", initial_state.STATE_TYPE)

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)
	
func _input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)

func change_state(new_state: StateTypes.State) -> void:
	if current_state:
		current_state.exit()
	
	current_state = states.get(new_state)
	
	if current_state:
		current_state.enter()
