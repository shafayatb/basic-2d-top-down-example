extends CharacterBody2D


@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = \
	animation_tree.get("parameters/playback")
	
const max_speed: int = 100
const acceleration: int = 9
const friction: int = 5

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

var input: Vector2 = Vector2.ZERO

func _ready() -> void:
	animation_tree.active = true

func _physics_process(delta: float) -> void:
	if knockback_timer > 0.0:
		velocity = knockback
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			knockback = Vector2.ZERO
	else:
		movement(delta)
	
	move_and_slide()
	
	if input != Vector2.ZERO:
		animation_tree["parameters/conditions/is_moving"] = true 
		animation_tree["parameters/conditions/not_moving"] = false
	else:
		animation_tree["parameters/conditions/is_moving"] = false 
		animation_tree["parameters/conditions/not_moving"] = true

	
	animation_tree["parameters/Idle/blend_position"] = input
	animation_tree["parameters/Move/blend_position"] = input
	
func movement(delta: float) -> void:
	input = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
	var lerp_weight = delta * (acceleration if input else friction)
	velocity = lerp(velocity, input * max_speed, lerp_weight)
	
func apply_knockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration
