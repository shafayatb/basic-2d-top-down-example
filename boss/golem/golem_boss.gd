extends CharacterBody2D

@export var melee_attack_range: int = 50
@export var projectile_attack_launch_range: int = 150
@export var bullet_node: PackedScene

@onready var debug: Label = $Debug
@onready var state_machine: StateMachine = $StateMachine
@onready var player_detection: Area2D = $PlayerDetection
@onready var detect_collision: CollisionShape2D = $PlayerDetection/CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var custom_health_bar: CustomHealthBar = $CanvasLayer/CustomHealthBar
@onready var sprite: Sprite2D = $Golem

var player: CharacterBody2D
var direction: Vector2

func _ready() -> void:
	add_to_group("enemy")
	set_physics_process(false)
	player = get_tree().get_first_node_in_group("Player")
	
func _process(delta: float) -> void:
	debug.text = state_machine.get_current_state()
	direction = player.position - position

func _physics_process(delta: float) -> void:
	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	velocity = direction.normalized() * 40
	
	move_and_slide()
