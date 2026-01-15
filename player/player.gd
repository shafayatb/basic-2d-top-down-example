extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = \
	animation_tree.get("parameters/playback")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: StateMachine = $StateMachine
@onready var knockback_state: KnockbackState = $StateMachine/KnockbackState

var input_direction: Vector2 = Vector2.ZERO
var last_facing_x: float = 1.0 

const sword_slash_preload = preload("res://attacks/sword_slash.tscn")

func _ready() -> void:
	animation_tree.active = true
