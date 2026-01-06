extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = \
	animation_tree.get("parameters/playback")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: StateMachine = $StateMachine
@onready var knockback_state: KnockbackState = $StateMachine/KnockbackState

var input_direction: Vector2 = Vector2.ZERO
var can_slash: bool = true
@export var slash_time: float = 0.2
@export var sword_return_time: float = 0.5
@export var weapon_damage: float = 1.0

const sword_slash_preload = preload("res://attacks/sword_slash.tscn")

func _ready() -> void:
	animation_player.connect("animation_finished", on_animation_finished)
	#animation_tree.active = true
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Attack") and can_slash:
		animation_player.speed_scale = animation_player.get_animation("slash").length / slash_time
		animation_player.play("slash")
		can_slash = false

func spawn_slash():
	var sword_slash = sword_slash_preload.instantiate()
	sword_slash.global_position = global_position
	sword_slash.get_node("AnimationPlayer").speed_scale = sword_slash.get_node("AnimationPlayer").get_animation("show_slash").length / slash_time 
	sword_slash.weapon_damage = weapon_damage
	get_parent().add_child(sword_slash)
	
func on_animation_finished(anim_name: StringName):
	if anim_name == "slash":
		animation_player.speed_scale = animation_player.get_animation("sword_return").length / sword_return_time
		animation_player.play("sword_return")
	else:
		can_slash = true
