extends Spell

class_name RangeSpell

export var speed : float = 600.0
var velocity : Vector2

func cast(_spell_owner : Wizard, spell_position : Position2D, spell_direction : Vector2, effect : Resource):
	.cast(_spell_owner, spell_position, spell_direction, effect)
	velocity = direction * speed
	rotation = atan2(direction.y, direction.x)
	pass

func _physics_process(delta):
	translate(velocity * delta)
	pass
