extends Node2D

class_name Spell

export (Resource) var spell_data
export var destroy_on_hit : bool = true
export (UtilityManager.SpellType) var spell_type = UtilityManager.SpellType.MELEE
export var spell_icon : Texture = null
var spell_info : Node2D = null
var wizard_id : int = -1
var spell_owner : Wizard = null
var spell_effect : Resource = null
var direction : Vector2
export var hit_area_path : NodePath
var hit_area : Area2D

func set_wizard_id(id : int):
	wizard_id = id
	pass

func initialize(id : int):
	wizard_id = id
	spell_info = $SpellInfo
	spell_info.initialize(spell_data)
	hit_area = get_node(hit_area_path)
	hit_area.connect("body_entered", self, "_on_spell_hit")
	pass

func cast(spell_position : Position2D, spell_direction : Vector2, effect : Resource):
	spell_owner = GameManager.get_wizard_by_id(wizard_id)
	global_position = spell_position.global_position
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
		body.take_damage(spell_info.get_damage(), spell_effect, _get_knockback_force(), spell_owner.global_position)
	_destroy(body)
	pass # Replace with function body.

func _destroy(body : Node2D):
	pass

func _get_knockback_force():
	return direction.normalized() * spell_info.get_knockback_force()

func get_name():
	return spell_info.get_name()

func get_type():
	return spell_type

func get_icon():
	return spell_icon

func get_cooldown():
	return spell_info.get_cooldown()
