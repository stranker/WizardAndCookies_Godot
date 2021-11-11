extends Node

var ice_spell  = preload("res://Objects/Spells/IceStake/IceStake.tscn")
var rock_spell  = preload("res://Objects/Spells/Rock/TheRock.tscn")
export (NodePath) var cast_position_node
export (NodePath) var spell_particles_node

onready var cast_position : Position2D = get_node(cast_position_node)
onready var spell_particles : Particles2D = get_node(spell_particles_node)
onready var spell_owner : Wizard = get_parent()
onready var first_skill : String = "first_skill_" + str(spell_owner.player_id)
onready var second_skill : String = "second_skill_" + str(spell_owner.player_id)

var spell_list : Array = [ice_spell, rock_spell]
var current_spell = null

export var is_casting : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_just_pressed(first_skill):
		_cast_skill(0)
	if Input.is_action_just_pressed(second_skill):
		_cast_skill(1)
	check_skill_release()
	pass

func check_skill_release():
	if !is_casting: return
	if Input.is_action_just_released(first_skill) or Input.is_action_just_released(second_skill):
		is_casting = false
		get_tree().root.add_child(current_spell)
		current_spell.call_deferred("cast", spell_owner, cast_position.global_position, get_cast_direction())
		current_spell = null
		spell_particles.emitting = false
	pass

func _cast_skill(idx : int):
	if is_casting: return
	is_casting = true
	current_spell = spell_list[idx].instance()
	spell_particles.emitting = true
	pass

func get_cast_direction():
	return Vector2(0,1)
