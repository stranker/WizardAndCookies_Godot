extends Resource
class_name SpellData

export (String) var s_name
# Float slider-min  max   step
export (float, 0.0, 10.0, 0.5) var s_damage
export (float, 0.0, 10.0, 0.5) var s_cooldown
export (float, 0.0, 10.0, 0.5) var s_range
export (float, 0.0, 1200.0 , 1.5) var s_knockback_force
export (float, 0.0, 5.0 , 0.5) var s_difficulty
export (Array, Resource) var s_effects = []

func add_effect(effect : Resource):
	s_effects.append(effect)
	pass
