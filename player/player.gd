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
var enemy: Node2D
var is_targeted: bool = false

const sword_slash_preload = preload("res://attacks/sword_slash.tscn")

func _ready() -> void:
	animation_tree.active = true
	detection_area.body_entered.connect(enemy_entered)
	detection_area.body_exited.connect(enemy_exited)

func enemy_entered(body: Node2D):
	if body.is_in_group("enemy"):
		enemy = body

func enemy_exited(body: Node2D):
	if body.is_in_group("enemy"):
		enemy = null
		body.targated(false)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Target"):
		if enemy:
			is_targeted = !is_targeted
			enemy.targated(is_targeted)
			
