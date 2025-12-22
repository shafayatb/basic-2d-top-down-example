extends RefCounted

class_name  StateInterface

var state_machine: StateMachineNew

func enter(prev_state: String = "") -> void:
	pass
	
func exit():
	pass

func update(delta: float):
	pass

func physics_update(delta: float):
	pass

func handle_input(event: InputEvent):
	pass
