extends KinematicBody2D

export (Resource) var spell_data
onready var spell_info = $SpellInfo
export var speed : float = 600.0
var spell_owner : Node2D

var velocity : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	spell_info.initialize(spell_data)
	pass # Replace with function body.

func _physics_process(delta):
	velocity.x = speed
	velocity = move_and_slide(velocity)
	pass

func cast(_spell_owner : Node2D, spell_position : Vector2):
	global_position = spell_position
	spell_owner = _spell_owner
	pass

func _on_DamageArea_body_entered(body):
	if body == spell_owner: return
	if !body.has_method("take_damage"): return
	body.take_damage(spell_info.get_damage())
	call_deferred("queue_free")
	pass # Replace with function body.
