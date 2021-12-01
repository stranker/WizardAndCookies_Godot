extends Control

export var spell_duration : float = 1
onready var anim : AnimationPlayer = $Anim
onready var spell_icon : TextureProgress = $Background/MarginContainer/SpellProgress

signal on_cooldown_end()

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_F2:
			_on_use(spell_duration)
			pass
	pass

func _on_use(duration : float):
	anim.play("Cooldown", -1, 1 / duration)
	pass

func _on_cooldown_end():
	anim.play("Ready")
	emit_signal("on_cooldown_end")
	pass

func _on_Anim_animation_finished(anim_name):
	if anim_name == "Cooldown":
		_on_cooldown_end()
	pass # Replace with function body.

func set_spell_texture(text : Texture):
	spell_icon.texture_under = text
	spell_icon.texture_progress = text
	pass
