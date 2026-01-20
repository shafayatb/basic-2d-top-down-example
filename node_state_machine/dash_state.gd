extends State

class_name  DashState

const STATE_TYPE = StateTypes.State.DASH
const DASH_SPEED: float = 500.0
const DASH_TIME: float = 0.12
var can_dash: bool = true
var dash_timer: float = 0.0
var dash_dir: Vector2 = Vector2.ZERO
const DASH_RELOAD_COST: float = 0.5
var dash_reload_time: float = 0.0
var player: CharacterBody2D

func enter() -> void:
	player = state_machine.get_parent()
	dash_timer = DASH_TIME
	dash_dir = Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up")
	).normalized()
	if dash_dir == Vector2.ZERO:
		dash_dir = Vector2(player.last_facing_x, 0)
	player.playback.travel("Dash")
	player.animation_tree["parameters/Dash/blend_position"] = dash_dir
	player.velocity = dash_dir * DASH_SPEED

func physics_update(delta: float):
	dash_timer -= delta
	if dash_timer > 0.0:
		player.velocity = dash_dir * DASH_SPEED
		player.move_and_slide()
	else:
		exit_dash()
		return
	

func exit_dash() -> void:
	var direction = Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up")
	)
	if direction != Vector2.ZERO:
		state_machine.change_state(StateTypes.State.MOVE)
	else:
		state_machine.change_state(StateTypes.State.IDLE)
	
