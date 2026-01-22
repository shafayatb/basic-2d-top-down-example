extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = \
	animation_tree.get("parameters/playback")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: StateMachine = $StateMachine
@onready var knockback_state: KnockbackState = $StateMachine/KnockbackState
@onready var targeting_system: Node2D = $TargetingSystem

var input_direction: Vector2 = Vector2.ZERO
var last_facing_x: float = 1.0 

func _ready() -> void:
	animation_tree.active = true
