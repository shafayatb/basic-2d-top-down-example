extends CharacterBody2D

var state_machine: StateMachineNew

func _ready() -> void:
	state_machine = StateMachineNew.new()
	state_machine.owner = self
	
	state_machine.add_state("idlestatenew", IdleStateNew.new())
	state_machine.add_state("movestatenew", MoveStateNew.new())
	state_machine.add_state("dashstatenew", DashStateNew.new())
	
	state_machine.set_initial_state("idlestatenew")

func _process(delta: float) -> void:
	state_machine.update(delta)
	
func _physics_process(delta: float) -> void:
	state_machine.physics_update(delta)

func _input(event: InputEvent) -> void:
	state_machine.handle_input(event)

func get_current_state() -> String:
	return state_machine.get_current_state_name()
