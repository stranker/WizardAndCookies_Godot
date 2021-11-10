extends Node2D

export (Resource) var spell_data

var spell_name : String
var spell_damage : float
var spell_cooldown : float
var spell_range : float
var spell_type : int

func initialize(data : SpellData):
	spell_name = data.s_name
	spell_damage = data.s_damage
	spell_cooldown = data.s_cooldown
	spell_range = data.s_range
	spell_type = data.s_type
	pass

func get_name():
	return spell_name

func get_damage():
	return spell_damage

func get_cooldown():
	return spell_cooldown

func get_range():
	return spell_range

func get_type():
	return spell_type
