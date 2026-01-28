extends State

class_name WalkState

const MAX_SPEED: float = 64.5
const ACCELERATION: float = 18.5
const FRICTION: float = 22.5

var player: CharacterBody2D

func enter():
	player = get_tree().get_first_node_in_group("Player")
	player.playback.travel("Move")

func physics_update(delta: float):
	var direction = Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up")
	).normalized()
	
	if direction.length() < 0.1:  # Almost no input
		var lerp_weight = delta * FRICTION
		player.velocity = lerp(player.velocity, Vector2.ZERO, lerp_weight)
		if player.velocity.length() < 5.0:  # Fully stopped
			state_machine.change_state(PlayerStates.IDLE)
			return
	
	player.input_direction = direction
	
	if player.targeting_system.is_locked_on:
		var facing_dir = player.targeting_system.get_facing_direction_to_enemy()
		player.last_facing_x = facing_dir
		var locked_blend = Vector2(facing_dir, direction.y)
		player.animation_tree["parameters/Move/blend_position"] = locked_blend
	else:
		player.animation_tree["parameters/Move/blend_position"] = direction
		if direction.x != 0:
			player.last_facing_x = sign(direction.x) 
	var acc_weight = delta * ACCELERATION
	player.velocity = lerp(player.velocity, direction * MAX_SPEED, acc_weight)
	
	player.move_and_slide()

func handle_input(event: InputEvent):
	if Input.is_action_just_pressed("Dash"):
		state_machine.change_state(PlayerStates.DASH)
