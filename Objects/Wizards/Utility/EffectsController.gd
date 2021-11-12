extends Node2D

var effect_scene = preload("res://Objects/Spells/Effects/Effect.tscn")
var active_effects : Array = []

onready var wizard : Wizard = get_parent()

func apply_effects(spell_effects : Array):
	for effect_data in spell_effects:
		if !_has_effect(effect_data):
			_add_effect(effect_data)
	pass

func _has_effect(new_effect : SpellEffect):
	for effect in active_effects:
		if new_effect.e_name == effect.get_name():
			print("Already have effect " + effect.get_name())
			return true
	return false

func _add_effect(effect_data : SpellEffect):
	var effect = effect_scene.instance()
	call_deferred("add_child", effect)
	effect.call_deferred("initialize", effect_data, wizard)
	effect.connect("effect_end", self, "on_effect_end")
	active_effects.append(effect)
	pass

func on_effect_end(effect : Effect):
	match effect.get_type():
		SpellManager.EffectType.FIRE:
			pass
		SpellManager.EffectType.ICE:
			wizard.set_can_move(true)
		SpellManager.EffectType.STUN:
			wizard.set_can_move(true)
	print("End effect " + effect.get_name())
	active_effects.erase(effect)
	effect.call_deferred("queue_free")
	pass
