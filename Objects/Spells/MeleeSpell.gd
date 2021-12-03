extends Spell

class_name MeleeSpeel

export var translate_force : Vector2 = Vector2.ZERO
export var translate_duration : float = 0.0

func cast(spell_position : Position2D, spell_direction : Vector2, effect : Resource):
	.cast(spell_position, spell_direction, effect)
	pass

