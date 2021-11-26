extends Node2D

onready var anim : AnimationTree = $AnimationTree
onready var animation_node = anim.get("parameters/StateMachine/playback")
onready var anim_conditions = "parameters/StateMachine/conditions/"
onready var wizard : Wizard = get_parent().get_parent()
onready var body : Sprite = $Body
onready var sprites : Array = body.get_children()
onready var timer : Timer = $Timer

var is_damaged : bool = false

func _ready():
	wizard.connect("on_state_change", self, "_on_wizard_state_change")
	wizard.connect("on_knockback", self, "_on_wizard_damaged")
	wizard.connect("on_knockback_recover", self, "_on_wizard_knockback_recover")
	pass

func _on_wizard_state_change(state : int, state_str : String):
	anim.set(anim_conditions + "idle", state == Wizard.MovementState.IDLE)
	anim.set(anim_conditions + "run", state == Wizard.MovementState.RUNNING)
	anim.set(anim_conditions + "jump", state == Wizard.MovementState.JUMPING)
	anim.set(anim_conditions + "fall", state == Wizard.MovementState.FALLING)
	anim.set(anim_conditions + "fly", state == Wizard.MovementState.FLYING)
	anim.set(anim_conditions + "cast", state == Wizard.MovementState.CASTING)
	anim.set(anim_conditions + "invoke", state == Wizard.MovementState.INVOKING)
	anim.set(anim_conditions + "hit", state == Wizard.MovementState.HIT)
	pass

func _on_wizard_damaged(is_knockback):
	is_damaged = true
	timer.start()
	pass

func _on_wizard_knockback_recover():
	is_damaged = false
	timer.stop()
	body.material.set_shader_param("whitening", 0.0)
	pass

func _on_Timer_timeout():
	var whitening = body.material.get_shader_param("whitening")
	body.material.set_shader_param("whitening", 0.8 if whitening != 0.8 else 0.2)
	timer.start()
	pass # Replace with function body.
