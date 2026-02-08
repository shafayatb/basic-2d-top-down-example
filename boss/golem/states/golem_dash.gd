extends State

class_name GolemDash

var boss: CharacterBody2D

const DASH_SPEED: float = 500.0
const DASH_TIME: float = 0.8
var dash_timer: float = 0.0
var dash_dir: Vector2 = Vector2.ZERO

func enter() -> void:
	boss = state_machine.get_parent()
	boss.animation_player.play("Glowing")
	dash_timer = DASH_TIME
	dash_dir = (boss.player.global_position - boss.global_position).normalized()
	boss.velocity = dash_dir * DASH_SPEED

func physics_update(delta: float):
	dash_timer -= delta
	if dash_timer > 0.0:
		boss.velocity = dash_dir * DASH_SPEED
		boss.move_and_slide()
	else:
		exit_dash()
		return
	
func exit_dash() -> void:
	state_machine.change_state(GolemStates.GOLEM_FOLLOW)
