extends State

class_name GolemIdle

var boss: CharacterBody2D 

var player_entered: bool = false:
	set(value):
		player_entered = value
		boss.detect_collision.set_deferred("disabled", value)
		boss.custom_health_bar.set_deferred("visible", value)

func enter():
	boss = state_machine.get_parent()
	boss.player_detection.body_entered.connect(_player_detected)

func _player_detected(body):
	player_entered = true
	state_machine.change_state(GolemStates.GOLEM_FOLLOW)

	
