extends Spell

class_name MeleeSpeel

func cast(_spell_owner : Wizard, spell_position : Vector2, spell_direction : Vector2):
	.cast(_spell_owner, spell_position, spell_direction)
	if is_zero_approx(spell_direction.x):
		scale.x = _spell_owner.get_visual_direction().x
	else:
		scale.x = 1 if spell_direction.x >= 0 else -1
	pass

