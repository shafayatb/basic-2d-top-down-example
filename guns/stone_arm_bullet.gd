extends Area2D

@export var acc_speed_multiplier = 700
@export var vel_limit = 150

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var acceleration: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
var player: CharacterBody2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	body_entered.connect(_body_entered)
	
func _physics_process(delta: float) -> void:
	
	acceleration = (player.position - position).normalized() * acc_speed_multiplier
	
	velocity += acceleration * delta
	rotation = velocity.angle()
	
	velocity = velocity.limit_length(vel_limit)
	
	position += velocity * delta
	
func _body_entered(body: Node2D):
	queue_free()
	
#TODO- free bullet if off screen.
