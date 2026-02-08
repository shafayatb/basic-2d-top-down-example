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
@onready var pivot: Node2D = $Pivot
@onready var hurt_box: CollisionShape2D = $CollisionShape2D


var player: CharacterBody2D
var direction: Vector2
var DEF = 0

var health: float = 100.0:
	set(value):
		health = value
		custom_health_bar.change_value(value)
		if value <= 0.0:
			custom_health_bar.visible = false
			state_machine.change_state(GolemStates.GOLEM_DEATH)
		elif value <= custom_health_bar.max_value /2 and DEF == 0:
			DEF = 5
			state_machine.change_state(GolemStates.GOLEM_ARMOR_BUFF)

func _ready() -> void:
	set_physics_process(false)
	custom_health_bar._setup_health_bar(health)
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
	
func take_damage(weapon_damage: float):
	if health <= 0.0:
		return
	health -= weapon_damage
