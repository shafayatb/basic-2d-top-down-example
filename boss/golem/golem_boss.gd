extends CharacterBody2D

@onready var debug: Label = $Debug
@onready var state_machine: StateMachine = $StateMachine
@onready var player_detection: Area2D = $PlayerDetection
@onready var detect_collision: CollisionShape2D = $PlayerDetection/CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var custom_health_bar: CustomHealthBar = $CanvasLayer/CustomHealthBar
@onready var sprite: Sprite2D = $Golem

var player: CharacterBody2D

func _ready() -> void:
	add_to_group("enemy")
	player = get_tree().get_first_node_in_group("Player")
	

func _physics_process(delta: float) -> void:
	debug.text = state_machine.get_current_state()
