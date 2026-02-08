extends State

class_name SwordAttack

@export var slash_time: float = 0.2
@export var sword_return_time: float = 0.5
@export var anim_tree_path: String = ""
@export var next_state: State

var weapon: Node2D
var combo_timer: float = 0.0
var anim_finished: bool = false
var combo_started: bool = false
const COMBO_TIME: float = 1.0

func enter():
	anim_finished = false
	combo_started = false
	weapon = state_machine.get_parent()
	combo_timer = COMBO_TIME
	if not weapon.animation_tree.is_connected("animation_finished", on_animation_finished):
		weapon.animation_tree.connect("animation_finished", on_animation_finished)
	var slash_anim_length = weapon.animation_player.get_animation(anim_tree_path).length
	weapon.animation_tree.set("parameters/TimeScale/scale", slash_anim_length / slash_time) 
	weapon.playback.travel(anim_tree_path)

func physics_update(delta: float):
	combo_timer -= delta
	if combo_timer <= 0.0 and not combo_started:
		play_sword_return()
		return

func exit():
	if weapon.animation_tree.is_connected("animation_finished", on_animation_finished):
		weapon.animation_tree.disconnect("animation_finished", on_animation_finished)

func on_animation_finished(anim_name: StringName):
	if anim_name == anim_tree_path:
		anim_finished = true
	elif anim_name == "sword_return":
		state_machine.change_state(SwordStates.SWORD_IDLE)
		
func play_sword_return():
	var slash_anim_length = weapon.animation_player.get_animation("sword_return").length
	weapon.animation_tree.set("parameters/TimeScale/scale", slash_anim_length / sword_return_time)
	weapon.playback.travel("SwordReturn")
		
func handle_input(_event: InputEvent):
	if Input.is_action_just_pressed("Attack"):
		if next_state and combo_timer > 0.0 and anim_finished:
			combo_started = true
			state_machine.change_state(next_state.name.to_lower())
	
