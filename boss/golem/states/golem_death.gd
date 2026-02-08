extends State

class_name GolemDeath

var boss: CharacterBody2D 

func enter():
	boss = state_machine.get_parent()
	boss.animation_player.play("Death")
	await boss.animation_player.animation_finished
	boss.animation_player.play("BossSlain")
