extends Node2D

var effect_scene = preload("res://Objects/Spells/Effects/Effect.tscn")
var active_effects : Array = []

onready var wizard : Wizard = get_parent()
onready var fire_effect : Node2D = $FireEffectWizard
onready var stun_effect : Node2D = $StunEffectWizard
onready var ice_effect : Node2D = $IceEffectWizard

signal on_effects_update(effects)

func _ready():
	connect("on_effects_update", wizard, "_on_effects_update")
	pass

func apply_effects(spell_effects : Array):
	for effect_data in spell_effects:
		if !_has_effect(effect_data):
			_add_effect(effect_data)
	call_deferred("emit_signal","on_effects_update", active_effects)
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
	set_visual_effect_active(effect_data.e_type)
	pass

func set_visual_effect_active(effect_type : int):
	match effect_type:
		SpellManager.EffectType.FIRE:
			fire_effect.visible = true
		SpellManager.EffectType.ICE:
			ice_effect.visible = true
			pass
		SpellManager.EffectType.STUN:
			stun_effect.visible = true
	pass

func on_effect_end(effect : Effect):
	match effect.get_type():
		SpellManager.EffectType.FIRE:
			fire_effect.visible = false
		SpellManager.EffectType.ICE:
			ice_effect.visible = false
			wizard.init_speed()
		SpellManager.EffectType.STUN:
			stun_effect.visible = false
			wizard.set_can_move(true)
	active_effects.erase(effect)
	effect.call_deferred("queue_free")
	call_deferred("emit_signal","on_effects_update", active_effects)
	pass
