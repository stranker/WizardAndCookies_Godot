extends Node2D

var ice_spell  = preload("res://Objects/Spells/Range/IceStake/IceStake.tscn")
var hammer_spell  = preload("res://Objects/Spells/Melee/Hammerfall/HammerFall.tscn")

export (NodePath) var cast_position_path

export var is_casting : bool = false

onready var cast_position : Position2D = get_node(cast_position_path)
onready var pivot : Node2D = $Pivot
onready var wizard : Wizard = get_parent()
onready var first_skill : String = "first_skill_" + str(wizard.player_id)
onready var second_skill : String = "second_skill_" + str(wizard.player_id)
onready var cast_anim : AnimationPlayer = $Pivot/CastAnimation
onready var can_cast_timer : Timer = $CanCastTimer
onready var effect_orb : Sprite = $EffectOrbPosition/EffectOrb
onready var effect_anim : AnimationPlayer = $EffectOrbPosition/EffectOrb/EffectOrbAnim
onready var orb_colors : Array = [Color.red, Color.cyan, Color.yellow]

var spell_list : Array = [ice_spell, hammer_spell]
var current_spell : Spell = null
var cast_direction : Vector2 = Vector2.RIGHT
var can_cast_spell : bool = true
var current_effect : Resource = null

signal on_casting_spell()
signal on_invoke_spell()
signal on_can_cast_spell()

func _ready():
	connect("on_casting_spell", wizard, "_on_casting_spell")
	connect("on_invoke_spell", wizard, "_on_invoke_spell")
	connect("on_can_cast_spell", wizard, "_on_can_cast_spell")
	wizard.connect("on_pickup_effect", self, "_on_pickup_effect")
	effect_orb.visible = false
	pass

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
	cast_direction = Vector2(wizard.get_horizontal_input(), wizard.get_vertical_input())
	cast_direction = cast_direction.normalized()
	if cast_direction == Vector2.ZERO:
		cast_direction = wizard.get_visual_direction()
	pivot.rotation = atan2(cast_direction.y, cast_direction.x)
	pass

func check_skill_release():
	if !is_casting: return
	if Input.is_action_just_released(first_skill) or Input.is_action_just_released(second_skill):
		is_casting = false
		if current_spell:
			if current_spell.get_type() == SpellManager.SpellType.MELEE:
				cast_position.add_child(current_spell)
			else:
				get_tree().root.add_child(current_spell)
			current_spell.cast(wizard, cast_position, cast_direction, current_effect)
			if current_effect:
				effect_anim.play("Cast")
			current_spell = null
			current_effect = null
			cast_anim.play_backwards("Casting")
		can_cast_spell = false
		can_cast_timer.start()
		emit_signal("on_invoke_spell")
	pass

func _cast_skill(idx : int):
	if is_casting or !can_cast_spell: return
	emit_signal("on_casting_spell")
	is_casting = true
	current_spell = spell_list[idx].instance()
	cast_anim.play("Casting")
	pass

func get_cast_direction():
	return cast_direction


func _on_CanCastTimer_timeout():
	can_cast_spell = true
	emit_signal("on_can_cast_spell")
	pass # Replace with function body.

func _on_pickup_effect(effect : Resource):
	current_effect = effect
	effect_anim.play("Idle")
	effect_orb.modulate = orb_colors[current_effect.e_type]
	pass
