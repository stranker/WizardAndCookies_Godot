extends Node2D

onready var anim : AnimationTree = $AnimationTree
onready var animation_node = anim.get("parameters/StateMachine/playback")
onready var anim_conditions = "parameters/StateMachine/conditions/"
onready var wizard : Wizard = get_parent().get_parent()

enum MovementState { FALLING, JUMPING, IDLE, RUNNING, FLYING, CASTING, LAST }

func _ready():
	wizard.connect("on_state_change", self, "_on_wizard_state_change")
	pass

func _on_wizard_state_change(state : int, state_str : String):
	anim.set(anim_conditions + "idle", state == MovementState.IDLE)
	anim.set(anim_conditions + "run", state == MovementState.RUNNING)
	anim.set(anim_conditions + "jump", state == MovementState.JUMPING)
	anim.set(anim_conditions + "fall", state == MovementState.FALLING)
	anim.set(anim_conditions + "fly", state == MovementState.FLYING)
	anim.set(anim_conditions + "cast", state == MovementState.CASTING)
	pass
