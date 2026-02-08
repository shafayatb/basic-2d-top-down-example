extends State

class_name GolemHomingMissile

var boss: CharacterBody2D 
var can_transition: bool = false

func enter():
	boss = state_machine.get_parent()
	boss.animation_player.play("RangedAttack")
	await boss.animation_player.animation_finished
	shoot()
	can_transition = true

func shoot():
	var bullet = boss.bullet_node.instantiate()
	bullet.position = boss.position
	get_tree().current_scene.add_child(bullet)
	
func physics_update(_delta: float):
	if can_transition:
		can_transition = false
		state_machine.change_state(GolemStates.GOLEM_DASH)
