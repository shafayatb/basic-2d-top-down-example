extends State

class_name SwordAttack

const STATE_TYPE = StateTypes.State.SWORD_ATTACK

@export var slash_time: float = 0.2
@export var sword_return_time: float = 0.5

var weapon: Node2D

func enter():
	weapon = state_machine.get_parent()
	if not weapon.animation_tree.is_connected("animation_finished", on_animation_finished):
		weapon.animation_tree.connect("animation_finished", on_animation_finished)
	weapon.playback.travel("Slash")

func exit():
	if weapon.animation_tree.is_connected("animation_finished", on_animation_finished):
		weapon.animation_tree.disconnect("animation_finished", on_animation_finished)

func on_animation_finished(anim_name: StringName):
	print(anim_name)
	if anim_name == "slash":
		weapon.playback.travel("SwordReturn")
	elif anim_name == "sword_return":
		print("changing to sword idle")
		state_machine.change_state(StateTypes.State.SWORD_IDLE)
