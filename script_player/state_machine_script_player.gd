extends CharacterBody2D

var state_machine: StateMachineNew

func _ready() -> void:
	state_machine = StateMachineNew.new()
	state_machine.owner = self
	
	state_machine.add_state(StateTypes.State.IDLE, IdleStateNew.new())
	state_machine.add_state(StateTypes.State.MOVE, MoveStateNew.new())
	state_machine.add_state(StateTypes.State.DASH, DashStateNew.new())
	
	state_machine.set_initial_state(StateTypes.State.IDLE)

func _process(delta: float) -> void:
	state_machine.update(delta)
	
func _physics_process(delta: float) -> void:
	state_machine.physics_update(delta)

func _input(event: InputEvent) -> void:
	state_machine.handle_input(event)

func get_current_state() -> StateTypes.State:
	return state_machine.get_current_state()
