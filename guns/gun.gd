extends Node2D

@onready var rotation_offset: Node2D = $RotationOffset
@onready var shoot_pos: Marker2D = $RotationOffset/Sprite2D/ShootPos
@onready var shoot_timer: Timer = $ShootTimer

@export var time_betweem_shot: float = 0.25

const bullet_scene = preload("res://guns/bullet.tscn")

var can_shoot: bool = true

func _ready() -> void:
	shoot_timer.connect("timeout", _shoot_timeout)
	shoot_timer.wait_time = time_betweem_shot
	
func _physics_process(delta: float) -> void:
	rotation_offset.rotation = lerp_angle(rotation_offset.rotation, (get_global_mouse_position() - global_position).angle(), 6.5 * delta)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Shoot"):
		shoot()
		can_shoot = false
		shoot_timer.start()

func shoot():
	var new_bullet = bullet_scene.instantiate()
	new_bullet.global_position = shoot_pos.global_position
	new_bullet.global_rotation = shoot_pos.global_rotation
	get_tree().root.add_child(new_bullet)
	
func _shoot_timeout() -> void:
	can_shoot = true
