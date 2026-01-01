extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = \
	animation_tree.get("parameters/playback")
@onready var state_machine: StateMachine = $StateMachine
@onready var knockback_state: KnockbackState = $StateMachine/KnockbackState

var input_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	animation_tree.active = true
