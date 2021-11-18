extends Node

var spell_data

var spell_name : String
var spell_damage : float
var spell_cooldown : float
var spell_range : float
var spell_knockback_force : float
var spell_effects : Array

func initialize(data : SpellData):
	spell_name = data.s_name
	spell_damage = data.s_damage
	spell_cooldown = data.s_cooldown
	spell_range = data.s_range
	spell_knockback_force = data.s_knockback_force
	spell_effects = data.s_effects
	pass

func get_name():
	return spell_name

func get_damage():
	return spell_damage

func get_cooldown():
	return spell_cooldown

func get_range():
	return spell_range

func get_knockback_force():
	return spell_knockback_force

func get_spell_effects():
	return spell_effects
