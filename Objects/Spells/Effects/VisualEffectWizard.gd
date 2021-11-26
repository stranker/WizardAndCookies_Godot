extends Node2D

class_name VisualEffectWizard

onready var anim : AnimationPlayer = $AnimationPlayer

func _ready():
	if anim:
		anim.connect("animation_finished", self, "_on_animation_finished")
	visible = false
	pass

func start():
	visible = true
	if !anim: return
	anim.play("Start")
	pass

func stop():
	if !anim:
		visible = false
		return
	anim.play("Stop")
	pass

func _on_animation_finished(anim_name : String):
	if anim_name == "Stop":
		visible = false
	pass
