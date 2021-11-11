extends Node

export var test_spell  = preload("res://Objects/Spells/IceStake/IceStake.tscn")
export (NodePath) var cast_position_node

onready var cast_position : Position2D = get_node(cast_position_node)
onready var spell_owner : Node2D = get_parent()
onready var first_skill : String = "first_skill_" + str(spell_owner.player_id)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_just_pressed(first_skill):
		_cast_skill()
	pass

func _cast_skill():
	var spell = test_spell.instance()
	get_tree().root.add_child(spell)
	spell.call_deferred("cast", spell_owner, cast_position.global_position)
	pass
