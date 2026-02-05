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
	
func exit():
	boss.set_physics_process(false)
