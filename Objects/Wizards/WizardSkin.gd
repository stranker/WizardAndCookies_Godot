extends Node2D

onready var anim : AnimationTree = $AnimationTree
onready var animation_node = anim.get("parameters/StateMachine/playback")
onready var anim_conditions = "parameters/StateMachine/conditions/"

enum MovementState { FALLING, JUMPING, IDLE, RUNNING, FLYING, LAST }

func set_state(state : int):
	anim.set(anim_conditions + "idle", state == MovementState.IDLE)
	anim.set(anim_conditions + "run", state == MovementState.RUNNING)
	anim.set(anim_conditions + "jump", state == MovementState.JUMPING)
	anim.set(anim_conditions + "fall", state == MovementState.FALLING)
	anim.set(anim_conditions + "fly", state == MovementState.FLYING)
	pass
