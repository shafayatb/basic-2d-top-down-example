extends State

class_name GolemFollow

@export var melee_attack_range: int = 100

var boss: CharacterBody2D
var direction: Vector2

func enter():
	boss = state_machine.get_parent()
	boss.animation_player.play("Idle")

func physics_update(delta: float):
	direction = boss.player.position - boss.position
	
	if direction.x < 0:
		boss.sprite.flip_h = true
	else:
		boss.sprite.flip_h = false
		
	var distance = direction.length()
	
	if distance < melee_attack_range:
		state_machine.change_state(GolemStates.GOLEM_MELEE_ATTACK)
	
	boss.velocity = direction.normalized() * 40
	
	boss.move_and_collide(boss.velocity * delta)
