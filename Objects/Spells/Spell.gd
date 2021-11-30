extends Area2D

class_name Spell

export (Resource) var spell_data
export var destroy_on_hit : bool = true
export (SpellManager.SpellType) var spell_type = SpellManager.SpellType.LAST
var spell_info : Node2D = null
var spell_owner : Wizard = null
var spell_effect : Resource = null
var direction : Vector2

func _initialize():
	spell_info = $SpellInfo
	spell_info.initialize(spell_data)
	connect("body_entered", self, "_on_spell_hit")
	pass

func cast(_spell_owner : Wizard, spell_position : Position2D, spell_direction : Vector2, effect : Resource):
	_initialize()
	global_position = spell_position.global_position
	spell_owner = _spell_owner
	direction = spell_direction
	spell_effect = effect
	pass

func add_effect(effect : Resource):
	spell_data.add_effect(effect)
	spell_info.initialize(spell_data)
	pass

func _on_spell_hit(body):
	if body == spell_owner: return
	if body.has_method("take_damage"):
		body.take_damage(spell_info.get_damage(), spell_effect, _get_knockback_force(), global_position)
	_destroy(body)
	pass # Replace with function body.

func _destroy(body : Node2D):
	pass

func _get_knockback_force():
	return direction.normalized() * spell_info.get_knockback_force()

func get_type():
	return spell_type
