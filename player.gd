extends CharacterBody2D

const max_speed: int = 100
const acceleration: int = 9
const friction: int = 5

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

func _physics_process(delta: float) -> void:
	if knockback_timer > 0.0:
		velocity = knockback
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			knockback = Vector2.ZERO
	else:
		movement(delta)
	
	move_and_slide()
	
func movement(delta: float) -> void:
	var input = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
	var lerp_weight = delta * (acceleration if input else friction)
	velocity = lerp(velocity, input * max_speed, lerp_weight)
	
func apply_knockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration
