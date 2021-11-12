extends Spell

class_name MeleeSpeel

func cast(_spell_owner : Node2D, spell_position : Vector2, spell_direction : Vector2):
	.cast(_spell_owner, spell_position, spell_direction)
	scale.x = 1 if spell_direction.x > 0 else -1
	pass

