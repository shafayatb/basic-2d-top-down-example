extends State

class_name GolemMeleeAttack

var boss: CharacterBody2D

func enter():
	boss = state_machine.get_parent()
	boss.animation_player.play("Melee")
	
func physics_update(_delta: float):
	if boss.direction.length() > boss.melee_attack_range:
		state_machine.change_state(GolemStates.GOLEM_FOLLOW)
