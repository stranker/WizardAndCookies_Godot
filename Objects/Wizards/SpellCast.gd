extends Node2D

export (NodePath) var cast_position_path
export var is_casting : bool = false

onready var cast_position : Position2D = get_node(cast_position_path)
onready var pivot : Node2D = $Pivot
onready var wizard : Wizard = get_parent()
onready var first_skill : String = "first_skill_" + str(wizard.player_id)
onready var second_skill : String = "second_skill_" + str(wizard.player_id)
onready var third_skill : String = "third_skill_" + str(wizard.player_id)
onready var cast_anim : AnimationPlayer = $Pivot/CastAnimation
onready var effect_orb : Sprite = $EffectOrbPosition/EffectOrb
onready var effect_anim : AnimationPlayer = $EffectOrbPosition/EffectOrb/EffectOrbAnim
onready var orb_particles : Particles2D = $EffectOrbPosition/EffectOrb/OrbParticles
onready var orb_colors : Array = [Color.red, Color.cyan, Color.yellow]

var spell_list : Array = []
var current_spell : Spell = null
var current_spell_idx : int = -1
var cast_direction : Vector2 = Vector2.RIGHT
var can_cast_spell : Array = [false, false, false]
var current_effect : Resource = null

signal on_casting_spell()
signal on_invoke_spell(spell, spell_id)
signal on_can_cast_spell()

func _ready():
	if wizard.player_id == -1: return
	spell_list = SpellManager.get_wizard_spells(wizard.player_id)
	for i in range(spell_list.size()):
		can_cast_spell[i] = true
	connect("on_casting_spell", wizard, "_on_casting_spell")
	connect("on_invoke_spell", wizard, "_on_invoke_spell")
	connect("on_can_cast_spell", wizard, "_on_can_cast_spell")
	wizard.connect("on_pickup_effect", self, "_on_pickup_effect")
	wizard.connect("on_cooldown_end", self, "_on_cooldown_end")
	effect_orb.visible = false
	var mat = orb_particles.process_material.duplicate()
	orb_particles.process_material = mat
	pass

func _input(event):
	if event is InputEventKey or event is InputEventJoypadButton:
		if event.is_action_pressed(first_skill):
			_cast_skill(0)
		elif event.is_action_pressed(second_skill):
			_cast_skill(1)
		elif event.is_action_pressed(third_skill):
			_cast_skill(2)
		elif event.is_action_released(first_skill) or event.is_action_released(second_skill):
			_check_skill_release()
	pass

func _physics_process(delta):
	_check_skill_direction()
	pass

func _check_skill_direction():
	if !is_casting: return
	cast_direction = Vector2(wizard.get_horizontal_input(), wizard.get_vertical_input())
	cast_direction = cast_direction.normalized()
	if cast_direction == Vector2.ZERO:
		cast_direction = wizard.get_visual_direction()
	pivot.rotation = atan2(cast_direction.y, cast_direction.x)
	pass

func _cast_skill(idx : int):
	if is_casting or !can_cast_spell[idx] or !_has_spell(idx): return
	current_spell_idx = idx
	is_casting = true
	current_spell = spell_list[idx].duplicate()
	current_spell.initialize(wizard.player_id)
	emit_signal("on_casting_spell")
	cast_anim.play("Casting")
	pass

func _check_skill_release():
	is_casting = false
	if current_spell:
		if current_spell.get_type() == UtilityManager.SpellType.MELEE:
			cast_position.add_child(current_spell)
		else:
			get_tree().root.add_child(current_spell)
		current_spell.cast(cast_position, cast_direction, current_effect)
		if current_effect:
			effect_anim.play("Cast")
		cast_anim.play_backwards("Casting")
		emit_signal("on_invoke_spell", current_spell, current_spell_idx)
		can_cast_spell[current_spell_idx] = false
		$Timer.start()
	current_spell = null
	current_effect = null
	pass

func get_cast_direction():
	return cast_direction

func _on_pickup_effect(effect : Resource):
	current_effect = effect
	effect_anim.play("Idle")
	effect_orb.modulate = orb_colors[current_effect.e_type]
	orb_particles.process_material.color = effect_orb.modulate
	pass

func _on_cooldown_end(spell_idx):
	can_cast_spell[spell_idx] = true
	pass

func _has_spell(spell_idx : int):
	return spell_idx < spell_list.size()

func _on_Timer_timeout():
	emit_signal("on_can_cast_spell")
	pass # Replace with function body.
