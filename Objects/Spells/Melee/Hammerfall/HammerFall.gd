extends MeleeSpeel

onready var anim : AnimationPlayer = $Anim

func cast(_spell_owner : Wizard, spell_position : Vector2, spell_direction : Vector2):
	.cast(_spell_owner, spell_position, spell_direction)
	if spell_direction.y > 0.1:
		anim.play("FallHit")
	else:
		anim.play("UpHit")
	pass
