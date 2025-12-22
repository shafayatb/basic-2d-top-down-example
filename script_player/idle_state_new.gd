extends StateInterface

class_name IdleStateNew

func enter(prev_state: StateTypes.State) -> void:
	print("IDLE STATE")

func handle_input(event: InputEvent):
	if Input.is_action_just_pressed("Dash"):
		state_machine.change_state(StateTypes.State.DASH)
		return
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") or \
			Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		state_machine.change_state(StateTypes.State.MOVE)
