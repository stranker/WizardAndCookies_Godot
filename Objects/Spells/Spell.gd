extends KinematicBody2D

export (Resource) var spell_data
onready var spell_info = $SpellInfo
var spell_owner : Wizard = null
var direction : Vector2

func _ready():
	spell_info.initialize(spell_data)
	pass # Replace with function body.

func cast(_spell_owner : Node2D, spell_position : Vector2, spell_direction : Vector2):
	global_position = spell_position
	spell_owner = _spell_owner
	direction = spell_direction
	pass

func _on_spell_hit(body):
	if body == spell_owner: return
	if !body.has_method("take_damage"): return
	body.take_damage(spell_info.get_damage())
	call_deferred("queue_free")
	pass # Replace with function body.
