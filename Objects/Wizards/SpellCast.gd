extends Node

var ice_spell  = preload("res://Objects/Spells/Range/IceStake/IceStake.tscn")
var hammer_spell  = preload("res://Objects/Spells/Melee/Hammerfall/HammerFall.tscn")
export (NodePath) var cast_position_path
export (NodePath) var spell_particles_path
export (NodePath) var cast_direction_path

onready var cast_position : Position2D = get_node(cast_position_path)
onready var spell_particles : Particles2D = get_node(spell_particles_path)
onready var cast_direction_node : Position2D = get_node(cast_direction_path)
onready var spell_owner : Wizard = get_parent()
onready var first_skill : String = "first_skill_" + str(spell_owner.player_id)
onready var second_skill : String = "second_skill_" + str(spell_owner.player_id)

var spell_list : Array = [ice_spell, hammer_spell]
var current_spell : Node2D = null
var cast_direction : Vector2 = Vector2.RIGHT

export var is_casting : bool = false

signal on_casting_spell()
signal on_invoke_spell()

# Called when the node enters the scene tree for the first time.
func _ready():
	cast_direction_node.visible = is_casting
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_just_pressed(first_skill):
		_cast_skill(0)
	if Input.is_action_just_pressed(second_skill):
		_cast_skill(1)
	check_skill_direction()
	check_skill_release()
	pass

func check_skill_direction():
	if !is_casting: return
	cast_direction = Vector2(spell_owner.get_horizontal_input(), spell_owner.get_vertical_input())
	cast_direction = cast_direction.normalized()
	if cast_direction == Vector2.ZERO:
		cast_direction = spell_owner.get_visual_direction()
	cast_direction_node.rotation = atan2(cast_direction.y, cast_direction.x)
	pass

func check_skill_release():
	if !is_casting: return
	if Input.is_action_just_released(first_skill) or Input.is_action_just_released(second_skill):
		is_casting = false
		emit_signal("on_invoke_spell")
		get_tree().root.add_child(current_spell)
		current_spell.call_deferred("cast", spell_owner, cast_position.global_position, cast_direction)
		current_spell = null
		spell_particles.emitting = is_casting
		cast_direction_node.visible = is_casting
	pass

func _cast_skill(idx : int):
	if is_casting: return
	emit_signal("on_casting_spell")
	is_casting = true
	current_spell = spell_list[idx].instance()
	spell_particles.emitting = is_casting
	cast_direction_node.visible = is_casting
	pass

func get_cast_direction():
	return cast_direction
