extends Area2D

export (Array, Resource) var effects_data
export (SpellManager.EffectType) var debug_effect_type = SpellManager.EffectType.FIRE
export var generate_debug_effect : bool = true
var visual_effects : Array = []
var effect : Resource = null
var picked : bool = false

signal on_pickup(effect)

func _ready():
	if generate_debug_effect:
		_generate_effect(false)
	pass

func init(pos : Vector2):
	global_position = pos
	visual_effects = [$Fire, $Ice, $Stun]
	_generate_effect(true)
	pass

func _generate_effect(is_random : bool):
	if !is_random:
		effect = effects_data[debug_effect_type]
	else:
		effect = effects_data[randi() % SpellManager.EffectType.LAST]
	visual_effects[effect.e_type].visible = true
	pass

func _on_EffectPickup_body_entered(body):
	if !body.has_method("pick_effect") and picked: return
	picked = true
	body.pick_effect(effect)
	emit_signal("on_pickup", self)
	pass
