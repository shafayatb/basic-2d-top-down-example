extends State

class_name IdleState

const STATE_TYPE = StateTypes.State.IDLE

var player: CharacterBody2D

func enter():
	print("IDLE STATE")
	player = state_machine.get_parent()
	player.velocity = Vector2.ZERO
	player.playback.travel("Idle")
	player.animation_tree["parameters/Idle/blend_position"] = player.input_direction

func handle_input(event: InputEvent):
	if Input.is_action_just_pressed("Dash"):
		state_machine.change_state(StateTypes.State.DASH)
		return
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") or \
			Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		state_machine.change_state(StateTypes.State.MOVE)
	
