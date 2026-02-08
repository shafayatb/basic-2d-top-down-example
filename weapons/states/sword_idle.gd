extends State

class_name SwordIdle

var weapon: Node2D

func enter():
	weapon = state_machine.get_parent()
	weapon.playback.travel("Idle")
	
func handle_input(event: InputEvent):
	if Input.is_action_just_pressed("Attack"):
		state_machine.change_state(SwordStates.SWORD_ATTACK)
