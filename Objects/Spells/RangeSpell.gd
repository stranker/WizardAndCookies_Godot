extends "res://Objects/Spells/Spell.gd"

export var speed : float = 600.0
var velocity : Vector2

func _physics_process(delta):
	velocity.x = speed
	velocity = move_and_slide(velocity)
	pass
