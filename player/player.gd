extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = \
	animation_tree.get("parameters/playback")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: StateMachine = $StateMachine
@onready var knockback_state: KnockbackState = $StateMachine/KnockbackState
@onready var detection_area: Area2D = $DetectionArea

var input_direction: Vector2 = Vector2.ZERO
var last_facing_x: float = 1.0 

var enemies_in_range: Array[Node2D] = []
var current_target: Node2D = null
var current_target_index: int = -1
var is_targeted: bool = false

var targeted_enemy: Node2D:
	get:
		return current_target

func _ready() -> void:
	animation_tree.active = true
	detection_area.body_entered.connect(enemy_entered)
	detection_area.body_exited.connect(enemy_exited)

func enemy_entered(body: Node2D):
	if body.is_in_group("enemy"):
		enemies_in_range.append(body)
		if body.has_signal("died"):
			body.died.connect(_on_enemy_death)

func _on_enemy_death(enemy: Node2D) -> void:
	enemies_in_range.erase(enemy)
	if enemy == current_target:
		current_target = null
		current_target_index = -1
		if is_targeted and enemies_in_range.size() > 0:
			_selected_closest_target()
		else:
			is_targeted = false

func enemy_exited(body: Node2D):
	if body.is_in_group("enemy"):
		enemies_in_range.erase(body)
		
		if body == current_target:
			body.targated(false)
			current_target = null
			current_target_index = -1
			
			if is_targeted and enemies_in_range.size() > 0:
				_selected_closest_target()
			else:
				is_targeted = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Target"):
		if is_targeted:
			_clear_target()
		else:
			_selected_closest_target()
	
	if event.is_action_pressed("SwitchTargets") and is_targeted:
		_switch_to_next_target()

func _selected_closest_target():
	if enemies_in_range.is_empty():
		return
		
	var closest_enemy: Node2D = null
	var closest_distance: float = INF
	
	for enemy in enemies_in_range:
		if not is_instance_valid(enemy):
			continue
		var distance = global_position.distance_to(enemy.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy
	
	if closest_enemy:
		_set_target(closest_enemy)

func _switch_to_next_target():
	if enemies_in_range.is_empty():
		_clear_target()
		return
	
	enemies_in_range = enemies_in_range.filter(func(e): return is_instance_valid(e))
	
	if enemies_in_range.is_empty():
		_clear_target()
		return
		
	if current_target and is_instance_valid(current_target):
		current_target.targated(false)
	
	current_target_index = (current_target_index + 1) % enemies_in_range.size()
	_set_target(enemies_in_range[current_target_index])
	
func _set_target(closest_enemy: Node2D):
	if current_target and is_instance_valid(current_target):
		current_target.targated(false)
	
	current_target = closest_enemy
	current_target_index = enemies_in_range.find(closest_enemy)
	is_targeted = true
	current_target.targated(true)

func _clear_target():
	if current_target and is_instance_valid(current_target):
		current_target.targated(false)
	current_target = null
	current_target_index = -1
	is_targeted = false
	
func get_direction_to_enemy() -> Vector2:
	if is_targeted and current_target and is_instance_valid(current_target):
		return (current_target.global_position - global_position).normalized()
	return Vector2.ZERO
	
func get_facing_direction_to_enemy() -> float:
	if is_targeted and current_target and is_instance_valid(current_target):
		return sign(current_target.global_position.x - global_position.x)
	return last_facing_x
