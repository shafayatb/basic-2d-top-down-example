extends Node2D

@onready var detection_area: Area2D = $DetectionArea
@onready var reticle: Sprite2D = $Reticle

var enemies_in_range: Array[Node2D] = []
var current_target: Node2D = null
var current_target_index: int = -1
var is_locked_on: bool = false

func _ready() -> void:
	detection_area.body_entered.connect(_enemy_entered)
	detection_area.body_exited.connect(_enemy_exited)
	reticle.visible = false
	reticle.top_level = true
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Target"):
		if is_locked_on:
			clear_target()
		else:
			selected_closest_target()
	
	if event.is_action_pressed("SwitchTargets") and is_locked_on:
		switch_to_next_target()
		
func _physics_process(_delta: float) -> void:
	if is_locked_on and current_target and is_instance_valid(current_target):
		reticle.global_position = current_target.global_position - Vector2(0, 50)
	
	if is_locked_on and (not current_target or not is_instance_valid(current_target)):
		_handle_target_lost()

func selected_closest_target():
	if enemies_in_range.is_empty():
		return
	
	var owner_pos = get_parent().global_position
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

func switch_to_next_target():
	enemies_in_range = enemies_in_range.filter(func(e): return is_instance_valid(e))
	
	if enemies_in_range.is_empty():
		clear_target()
		return
	
	current_target_index = (current_target_index + 1) % enemies_in_range.size()
	_set_target(enemies_in_range[current_target_index])

func clear_target():
	current_target = null
	current_target_index = -1
	is_locked_on = false
	reticle.visible = false

func get_facing_direction_to_enemy() -> float:
	if is_locked_on and current_target and is_instance_valid(current_target):
		return sign(current_target.global_position.x - global_position.x)
	return 1.0
	
func get_direction_to_enemy() -> Vector2:
	if is_locked_on and current_target and is_instance_valid(current_target):
		return (current_target.global_position - global_position).normalized()
	return Vector2.ZERO
	
func _set_target(closest_enemy: Node2D):
	current_target = closest_enemy
	current_target_index = enemies_in_range.find(closest_enemy)
	is_locked_on = true
	
	reticle.visible = true
	reticle.global_position = current_target.global_position - Vector2(0, 50)

func _handle_target_lost() -> void:
	enemies_in_range = enemies_in_range.filter(func(e): return is_instance_valid(e))
	
	if enemies_in_range.size() > 0:
		selected_closest_target()
	else:
		clear_target()

func _enemy_entered(body: Node2D):
	if body.is_in_group("enemy"):
		enemies_in_range.append(body)
		if body.has_signal("died"):
			body.died.connect(_on_enemy_death)

func _on_enemy_death(enemy: Node2D) -> void:
	enemies_in_range.erase(enemy)
	if enemy == current_target:
		current_target = null
		current_target_index = -1
		if is_locked_on and enemies_in_range.size() > 0:
			selected_closest_target()
		else:
			is_locked_on = false
			reticle.visible = false
			
func _enemy_exited(body: Node2D):
	if body.is_in_group("enemy"):
		enemies_in_range.erase(body)
		if body == current_target:
			_handle_target_lost()
