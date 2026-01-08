extends Sprite2D

@onready var shadow: Sprite2D = $Shadow
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var distance_timer: Timer = $DistanceTimer

@export var speed: float = 120.0

func _ready() -> void:
	animation_player.connect("animation_finished", animation_finished)
	distance_timer.connect("timeout", bullet_timout)

func _physics_process(delta: float) -> void:
	global_position += Vector2(1, 0).rotated(rotation) * speed * delta
	shadow.position = Vector2(-2, 2).rotated(-rotation)
	if ray_cast_2d.is_colliding():
		animation_player.play("remove")

func animation_finished(anim_name: StringName):
	if anim_name == "remove":
		queue_free()
		
func bullet_timout():
	animation_player.play("remove")
