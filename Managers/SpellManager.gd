extends Node

var ice_stake = preload("res://Objects/Spells/Range/IceStake/IceStake.tscn")
var rolling_pin = preload("res://Objects/Spells/Melee/Hammerfall/HammerFall.tscn")

var wizards_spells : Dictionary = {1:[], 2:[]}

func _ready():
	initialize_test_spells()
	pass

func initialize_test_spells():
	add_wizard_spell(1, ice_stake)
	add_wizard_spell(1, rolling_pin)
	add_wizard_spell(2, rolling_pin)
	add_wizard_spell(2, ice_stake)
	pass

func add_wizard_spell(wizard_id : int, spell_scene : PackedScene):
	var spell = spell_scene.instance()
	spell.initialize(wizard_id)
	wizards_spells[wizard_id].append(spell)
	pass

func get_wizard_spells(player_id : int):
	return wizards_spells[player_id]
