extends RefCounted

class_name StateMachineNew

var current_state: StateInterface
var states: Dictionary = {}
var current_state_id: StateTypes.State
var owner

func add_state(id: StateTypes.State, state: StateInterface) -> void:
	states[id] = state
	state.state_machine = self

func set_initial_state(id: StateTypes.State) -> void:
	change_state(id)

func change_state(new_id: StateTypes.State) -> void:
	var prev_id := current_state_id

	if current_state:
		current_state.exit()

	current_state_id = new_id
	current_state = states.get(new_id)

	if current_state:
		current_state.enter(prev_id)
	else:
		push_warning("State not found: %s" % new_id)

func update(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func physics_update(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)
	
func handle_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event) 

func get_current_state() -> StateTypes.State:
	return current_state_id
