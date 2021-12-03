extends Spell

class_name MeleeSpeel

export var translate_force : float = 0
export var translate_duration : float = 0.0

func cast(spell_position : Position2D, spell_direction : Vector2, effect : Resource):
	.cast(spell_position, spell_direction, effect)
	pass

