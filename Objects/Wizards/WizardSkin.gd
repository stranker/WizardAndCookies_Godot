extends Node2D

onready var anim : AnimationTree = $AnimationTree
onready var animation_node = anim.get("parameters/StateMachine/playback")
onready var anim_conditions = "parameters/StateMachine/conditions/"
onready var wizard : Wizard = get_parent().get_parent()

func _ready():
	wizard.connect("on_state_change", self, "_on_wizard_state_change")
	pass

func _on_wizard_state_change(state : int, state_str : String):
	anim.set(anim_conditions + "idle", state == Wizard.MovementState.IDLE)
	anim.set(anim_conditions + "run", state == Wizard.MovementState.RUNNING)
	anim.set(anim_conditions + "jump", state == Wizard.MovementState.JUMPING)
	anim.set(anim_conditions + "fall", state == Wizard.MovementState.FALLING)
	anim.set(anim_conditions + "fly", state == Wizard.MovementState.FLYING)
	anim.set(anim_conditions + "cast", state == Wizard.MovementState.CASTING)
	anim.set(anim_conditions + "invoke", state == Wizard.MovementState.INVOKING)
	pass
