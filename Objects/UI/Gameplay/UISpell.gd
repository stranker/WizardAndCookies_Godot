extends Control

onready var anim : AnimationPlayer = $Anim
onready var background : TextureProgress = $Background
onready var spell_icon : TextureProgress = $Background/MarginContainer/SpellProgress
var spell : Spell = null
var spell_idx : int = -1

signal on_cooldown_end(spell_idx)

func _ready():
	background.visible = false
	pass

func set_spell(_spell):
	spell = _spell
	set_spell_texture(spell.get_icon())
	background.visible = true
	pass

func start_cooldown(_spell_idx : int):
	spell_idx = _spell_idx
	_on_use(spell.get_cooldown())
	pass

func _on_use(duration : float):
	if duration <= 0.1:
		duration = 0.5
	anim.play("Cooldown", -1, 1.0 / duration)
	pass

func _on_cooldown_end():
	anim.play("Ready")
	emit_signal("on_cooldown_end", spell_idx)
	pass

func _on_Anim_animation_finished(anim_name):
	if anim_name == "Cooldown":
		_on_cooldown_end()
	pass # Replace with function body.

func set_spell_texture(text : Texture):
	spell_icon.texture_under = text
	spell_icon.texture_progress = text
	pass

func get_spell_name():
	return spell.get_name()
