extends State

class_name IdleState

const STATE_TYPE = StateTypes.State.IDLE

var player: CharacterBody2D

func enter():
	print("IDLE STATE")
	player = get_tree().get_first_node_in_group("Player")
	player.velocity = Vector2.ZERO
	player.playback.travel("Idle")
	
	if player.targeting_system.is_locked_on:
		var facing_dir = player.targeting_system.get_facing_direction_to_enemy()
		player.last_facing_x = facing_dir
		player.animation_tree["parameters/Idle/blend_position"] = facing_dir
	else:
		player.animation_tree["parameters/Idle/blend_position"] = player.last_facing_x

func physics_update(_delta: float):
	if player.targeting_system.is_locked_on:
		var facing_dir = player.targeting_system.get_facing_direction_to_enemy()
		if facing_dir != player.last_facing_x:
			player.last_facing_x = facing_dir
			player.animation_tree["parameters/Idle/blend_position"] = facing_dir

func handle_input(event: InputEvent):
	if Input.is_action_just_pressed("Dash"):
		state_machine.change_state(StateTypes.State.DASH)
		return
	if Input.is_action_pressed("Up") or Input.is_action_pressed("Down") or \
			Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
		state_machine.change_state(StateTypes.State.MOVE)
	
