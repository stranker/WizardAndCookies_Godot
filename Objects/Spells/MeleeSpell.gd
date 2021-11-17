extends Spell

class_name MeleeSpeel

export var translate_force : Vector2 = Vector2.ZERO
export var translate_duration : float = 0.0

func cast(_spell_owner : Wizard, spell_position : Position2D, spell_direction : Vector2):
	.cast(_spell_owner, spell_position, spell_direction)
	pass

