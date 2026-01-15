extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = \
	animation_tree.get("parameters/WeaponStates/playback")
@onready var sword_attack: SwordAttack = $StateMachine/SwordAttack

@export var weapon_damage: float = 1.0

const sword_slash_preload = preload("res://attacks/sword_slash.tscn")
var player: CharacterBody2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	animation_tree.active = true
		
func spawn_slash():
	var sword_slash = sword_slash_preload.instantiate()
	var facing_dir = player.input_direction
	if facing_dir == Vector2.ZERO:
		facing_dir = Vector2(player.last_facing_x, 0)
		
	sword_slash.direction = facing_dir + player.global_position
	if facing_dir.x == -1:
		sword_slash.scale = Vector2(1.0,-1.0)
	sword_slash.global_position = player.global_position
	sword_slash.get_node("AnimationPlayer").speed_scale = \
		sword_slash.get_node("AnimationPlayer").get_animation("show_slash").length / sword_attack.slash_time 
	sword_slash.weapon_damage = weapon_damage
	get_tree().root.add_child(sword_slash)
