extends CharacterBody2D

const MAX_SPEED: float = 64.5
const ACCELERATION: float = 18.5
const FRICTION: float = 22.5

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

#Dash
const DASH_SPEED: float = 1500.0
const DASH_TIME: float = 0.12
var can_dash: bool = true
var dash_timer: float = 0.0
var dash_dir: Vector2 = Vector2.ZERO
const DASH_RELOAD_COST: float = 0.5
var dash_reload_time: float = 0.0

func _physics_process(delta: float) -> void:
	if knockback_timer > 0.0:
		velocity = knockback
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			knockback = Vector2.ZERO
	else:
		dash_logic(delta)
		if dash_timer == 0.0:
			movement(delta)
	
	move_and_slide()
	
func movement(delta: float) -> void:
	var input: Vector2 = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()
	
	var velocity_weight_x: float = 1.0 - exp( - (ACCELERATION if input.x else FRICTION) * delta)
	velocity.x = lerp(velocity.x, input.x * MAX_SPEED, velocity_weight_x)
	var velocity_weight_y: float = 1.0 - exp( - (ACCELERATION if input.y else FRICTION) * delta)
	velocity.y = lerp(velocity.y, input.y * MAX_SPEED, velocity_weight_y)
	
	
func apply_knockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration
	
func dash_logic(delta: float) -> void:
	if can_dash and Input.is_action_just_pressed("Dash"):
		can_dash = false
		dash_timer = DASH_TIME
		dash_reload_time = DASH_RELOAD_COST
		
		dash_dir = global_position.direction_to(global_position + velocity)
		velocity = dash_dir * DASH_SPEED
	if dash_timer > 0.0: 
		dash_timer = max(0.0, dash_timer - delta)
	else:
		if dash_reload_time > 0.0:
			dash_reload_time -= delta
		else:
			can_dash = true
