extends State

class_name GolemLaserBeam

var boss: CharacterBody2D
var can_transition: bool = false

func enter():
	boss = state_machine.get_parent()
	await play_animation("LaserCast")
	await play_animation("Laser")
	can_transition = true
	
	
func play_animation(anim_name: String):
	boss.animation_player.play(anim_name)
	await boss.animation_player.animation_finished
	
func set_target():
	boss.pivot.rotation = (boss.direction - boss.pivot.position).angle()

func physics_update(_delta: float):
	if can_transition:
		can_transition = false
		state_machine.change_state(GolemStates.GOLEM_DASH)
