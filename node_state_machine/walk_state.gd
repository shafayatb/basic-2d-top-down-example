extends State

class_name WalkState

const STATE_TYPE = StateTypes.State.MOVE
const MAX_SPEED: float = 64.5
const ACCELERATION: float = 18.5
const FRICTION: float = 22.5

var player: CharacterBody2D

func enter():
	player = state_machine.get_parent()
	player.playback.travel("Move")

func physics_update(delta: float):
	var character = state_machine.get_parent()
	var direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
	if direction.length() < 0.1:  # Almost no input
		var lerp_weight = delta * FRICTION
		player.velocity = lerp(player.velocity, Vector2.ZERO, lerp_weight)
		if player.velocity.length() < 5.0:  # Fully stopped
			state_machine.change_state(StateTypes.State.IDLE)
			return
	
	player.input_direction = direction
	player.animation_tree["parameters/Move/blend_position"] = direction
	var acc_weight = delta * ACCELERATION
	character.velocity = lerp(character.velocity, direction * MAX_SPEED, acc_weight)
	if direction.x != 0:
		player.last_facing_x = sign(direction.x)
	character.move_and_slide()

func handle_input(event: InputEvent):
	if Input.is_action_just_pressed("Dash"):
		state_machine.change_state(StateTypes.State.DASH)
