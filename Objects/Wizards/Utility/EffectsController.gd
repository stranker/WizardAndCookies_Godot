extends Node2D

var effect_scene = preload("res://Objects/Spells/Effects/Effect.tscn")
var active_effects : Array = []

onready var wizard : Wizard = get_parent()
onready var visual_effects : Array = [$FireEffectWizard, $IceEffectWizard, $StunEffectWizard]

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

func apply_effect(spell_effect : Resource):
	if !spell_effect: return
	_add_effect(spell_effect)
	call_deferred("emit_signal","on_effects_update", active_effects)
	pass

func _has_effect(new_effect : SpellEffect):
	for effect in active_effects:
		if new_effect.e_name == effect.get_name():
			return true
	return false

func _add_effect(effect_data : SpellEffect):
	var effect = effect_scene.instance()
	call_deferred("add_child", effect)
	effect.call_deferred("initialize", effect_data, wizard)
	effect.connect("effect_end", self, "on_effect_end")
	active_effects.append(effect)
	set_effect_active(effect_data.e_type, true)
	pass

func set_effect_active(effect_type : int, is_visible : bool):
	visual_effects[effect_type].visible = is_visible
	match effect_type:
		SpellManager.EffectType.FIRE:
			pass
		SpellManager.EffectType.ICE:
			wizard.init_speed()
		SpellManager.EffectType.STUN:
			wizard.set_can_move(true)
	pass

func on_effect_end(effect : Effect):
	set_effect_active(effect.get_type(), false)
	active_effects.erase(effect)
	effect.call_deferred("queue_free")
	call_deferred("emit_signal","on_effects_update", active_effects)
	pass
