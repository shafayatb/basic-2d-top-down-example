extends State

class_name IdleState

func enter():
	print("IDLE STATE")

func handle_input(event: InputEvent):
	if Input.is_action_just_pressed("Dash"):
		state_machine.change_state("dashstate")
		return
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") or \
			Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		state_machine.change_state("walkstate")
	
