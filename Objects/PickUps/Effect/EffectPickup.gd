extends Area2D

export (Array, Resource) var effects_data
export (SpellManager.EffectType) var debug_effect_type = SpellManager.EffectType.LAST
export var generate_debug_effect : bool = true
var effects : Array = [$Fire, $Ice, $Stun]
var effect : Resource = null

func _ready():
	if generate_debug_effect:
		_generate_debug_effect()
	pass

func _generate_debug_effect():
	effect = effects_data[debug_effect_type]
	match debug_effect_type:
		SpellManager.EffectType.ICE:
			$Ice.visible = true
		SpellManager.EffectType.FIRE:
			$Fire.visible = true
		SpellManager.EffectType.STUN:
			$Stun.visible = true
	pass

func _on_EffectPickup_body_entered(body):
	if !body.has_method("pick_effect"): return
	body.pick_effect(effect)
	call_deferred("queue_free")
	pass # Replace with function body.
