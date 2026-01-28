extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D

var weapon_damage: float = 1.0
var direction: Vector2 = Vector2.ZERO
var animation_name: String = "show_slash"

func _ready() -> void:
	look_at(direction)
	animation_player.connect("animation_finished", animation_finished)
	area_2d.connect("body_entered",body_entered)
	animation_player.play(animation_name)

func animation_finished(anim_name: StringName):
	if anim_name == animation_name:
		queue_free()

func body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.take_damage(weapon_damage)
