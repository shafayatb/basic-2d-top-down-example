extends CharacterBody2D

@onready var player_node: CharacterBody2D = get_parent().get_node("Player")
@onready var hit_area: Area2D = $HitArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var health: float = 3.0

var speed: float = 180.0

func _ready() -> void:
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
		body.knockback_state.apply_knockback(knockback_direction, 500.0, 0.55)
		body.state_machine.change_state(StateTypes.State.KNOCKBACK)

func take_damage(weapon_damage: float):
	animation_player.play("take_damage")
	health -= weapon_damage
	if health <= 0.0:
		queue_free()
