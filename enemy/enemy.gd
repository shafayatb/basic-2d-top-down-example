extends CharacterBody2D

@onready var player_node: CharacterBody2D = get_parent().get_node("Player")
@onready var hit_area: Area2D = $HitArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var custom_health_bar: CustomHealthBar = $CustomHealthBar

@export var health: float = 10.0
@export var knockback_force: float = 150.0
@export var knockback_duration: float = 0.55

signal died(enemy: Node2D)

const  DAMAGE_LABEL:PackedScene = preload("uid://dhsulhnscgn05")

var speed: float = 180.0

func _ready() -> void:
	custom_health_bar._setup_health_bar(health)
	add_to_group("enemy")
	hit_area.body_entered.connect(_hit)
	
func _physics_process(delta: float) -> void:
	pass
	#if player_node:
		#var direction = (player_node.global_position - global_position).normalized()
		#look_at(player_node.global_position)
		#velocity = lerp(velocity, direction * speed, 0.5 * delta)
		#move_and_slide()


func _hit(body: Node2D)-> void:
	if body == player_node:
		var knockback_direction = (body.global_position - global_position).normalized()
		body.knockback_state.apply_knockback(knockback_direction, knockback_force, knockback_duration)
		body.state_machine.change_state(StateTypes.State.KNOCKBACK)

func take_damage(weapon_damage: float):
	animation_player.play("take_damage")
	health -= weapon_damage
	custom_health_bar.change_value(health)
	show_damage_label(weapon_damage)
	if health <= 0.0:
		died.emit(self)
		queue_free()
		
func show_damage_label(weapon_damage: float):
	var new_damage_label = DAMAGE_LABEL.instantiate() as Label
	new_damage_label.text = str(int(weapon_damage) * (randi() % 100))
	new_damage_label.global_position = global_position + Vector2(-25.0, -80.0)
	get_tree().current_scene.call_deferred("add_child", new_damage_label)
