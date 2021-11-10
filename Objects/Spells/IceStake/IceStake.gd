extends KinematicBody2D

export (Resource) var spell_data
onready var spell_info = $SpellInfo
export var speed : float = 600.0

var velocity : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	spell_info.initialize(spell_data)
	pass # Replace with function body.

func _physics_process(delta):
	velocity.x = speed
	velocity = move_and_slide(velocity)
	pass
