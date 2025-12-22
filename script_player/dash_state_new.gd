extends StateInterface

class_name DashStateNew

var character: CharacterBody2D

const DASH_SPEED: float = 1500.0
const DASH_TIME: float = 0.12

var dash_timer: float = 0.0
var dash_dir: Vector2 = Vector2.ZERO

func enter(prev_state: StateTypes.State) -> void:
	character = state_machine.owner
	
	dash_timer = DASH_TIME
	dash_dir = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	if dash_dir == Vector2.ZERO:
		dash_dir = Vector2.RIGHT.normalized()
	character.velocity = dash_dir * DASH_SPEED
	
func physics_update(delta: float):
	dash_timer -= delta
	if dash_timer > 0.0:
		character.velocity = dash_dir * DASH_SPEED
	else:
		exit_dash()
	character.move_and_slide()

func exit_dash() -> void:
	var direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	if direction != Vector2.ZERO:
		state_machine.change_state(StateTypes.State.MOVE)
	else:
		state_machine.change_state(StateTypes.State.IDLE)
