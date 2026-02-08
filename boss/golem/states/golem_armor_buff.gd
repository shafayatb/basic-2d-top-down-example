extends State

class_name GolemArmorBuff

var boss: CharacterBody2D
var can_transition: bool = false

func enter():
	boss = state_machine.get_parent()
	boss.animation_player.play("ArmorBuff")
	await boss.animation_player.animation_finished
	can_transition = true

func physics_update(_delta: float):
	if can_transition:
		can_transition = false
		state_machine.change_state(GolemStates.GOLEM_FOLLOW)
