extends Area2D

class_name Spell

export (Resource) var spell_data
export var destroy_on_hit : bool = true
onready var spell_info = $SpellInfo
var spell_owner : Wizard = null
var direction : Vector2

func _ready():
	spell_info.initialize(spell_data)
	connect("body_entered", self, "_on_spell_hit")
	pass # Replace with function body.

func cast(_spell_owner : Wizard, spell_position : Vector2, spell_direction : Vector2):
	global_position = spell_position
	spell_owner = _spell_owner
	direction = spell_direction
	pass

func _on_spell_hit(body):
	if body == spell_owner: return
	if !body.has_method("take_damage"): return
	body.take_damage(spell_info.get_damage(), spell_info.get_spell_effects(), _get_knockbak_force())
	if destroy_on_hit:
		call_deferred("queue_free")
	pass # Replace with function body.

func _get_knockbak_force():
	return direction.normalized() * spell_info.get_knockback_force()
