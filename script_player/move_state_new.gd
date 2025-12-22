extends StateInterface

class_name MoveStateNew

var character: CharacterBody2D

const MAX_SPEED: float = 64.5
const ACCELERATION: float = 18.5
const FRICTION: float = 22.5

func enter(prev_state: String = "") -> void:
	character = state_machine.owner
	
func physics_update(delta: float):
	var direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
	if direction.x == 0 and direction.y == 0:
		state_machine.change_state("idlestatenew")
		return
		
	var lerp_weight = delta * (ACCELERATION if direction else FRICTION)
	character.velocity = lerp(character.velocity, direction * MAX_SPEED, lerp_weight)
	character.move_and_slide()

func handle_input(event: InputEvent):
	if Input.is_action_just_pressed("Dash"):
		state_machine.change_state("dashstatenew")
