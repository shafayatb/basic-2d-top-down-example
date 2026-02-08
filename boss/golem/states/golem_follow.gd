extends State

class_name GolemFollow

var boss: CharacterBody2D


func enter():
	boss = state_machine.get_parent()
	boss.animation_player.play("Idle")
	boss.set_physics_process(true)

func physics_update(delta: float):
		
	var distance = boss.direction.length()
	
	if distance < boss.melee_attack_range:
		state_machine.change_state(GolemStates.GOLEM_MELEE_ATTACK)
	elif distance > boss.projectile_attack_launch_range:
		var rand_attack = randi() % 2
		match rand_attack:
			0:
				state_machine.change_state(GolemStates.GOLEM_HOMING_MISSILE)
			1:
				state_machine.change_state(GolemStates.GOLEM_LASER_BEAM)
	
func exit():
	boss.set_physics_process(false)
