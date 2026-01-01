extends State

class_name KnockbackState

const STATE_TYPE = StateTypes.State.KNOCKBACK

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

var player: CharacterBody2D

func enter():
	player = state_machine.get_parent()

func physics_update(delta: float):
	player.velocity = knockback
	knockback_timer -= delta
	if knockback_timer <= 0.0:
		knockback = Vector2.ZERO
		state_machine.change_state(StateTypes.State.IDLE)
	player.move_and_slide()

func apply_knockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration
