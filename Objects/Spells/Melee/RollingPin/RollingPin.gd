extends MeleeSpeel

onready var anim : AnimationPlayer = $Anim

func cast(spell_position : Position2D, spell_direction : Vector2, effect : Resource):
	.cast(spell_position, spell_direction, effect)
	if abs(spell_direction.x) > abs(spell_direction.y):
		anim.play("SideHit")
		spell_owner.set_translate_force(Vector2(translate_force * spell_direction.x, 0), translate_duration)
	else:
		if spell_direction.y >= 0:
			anim.play("FallHit")
			spell_owner.set_translate_force(Vector2(0,translate_force), translate_duration)
		else:
			anim.play("UpHit")
			spell_owner.set_translate_force(Vector2(0,-translate_force), translate_duration)
	pass

func _destroy(body : Node2D):
	if is_queued_for_deletion(): return
	anim.stop()
	yield(get_tree().create_timer(0.5),"timeout")
	queue_free()
	pass
