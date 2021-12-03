extends MeleeSpeel

onready var anim : AnimationPlayer = $Anim

func cast(spell_position : Position2D, spell_direction : Vector2, effect : Resource):
	.cast(spell_position, spell_direction, effect)
	if spell_direction.y >= 0:
		anim.play("FallHit")
		spell_owner.set_translate_force(translate_force, translate_duration)
	else:
		anim.play("UpHit")
		spell_owner.set_translate_force(Vector2(translate_force.x,-translate_force.y), 0.3)
	pass

func _destroy(body : Node2D):
	if is_inside_tree():
		anim.stop()
		yield(get_tree().create_timer(0.5),"timeout")
		queue_free()
	pass
