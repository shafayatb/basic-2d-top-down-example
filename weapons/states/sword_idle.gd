extends State

class_name SwordIdle

const STATE_TYPE = StateTypes.State.SWORD_IDLE

var weapon: Node2D

func enter():
	print("Sword Idle")
	weapon = state_machine.get_parent()
	weapon.playback.travel("Idle")
	
func handle_input(event: InputEvent):
	if Input.is_action_just_pressed("Attack"):
		state_machine.change_state(StateTypes.State.SWORD_ATTACK)
