extends Node

# Spells scenes
var ice_stake = preload("res://Objects/Spells/Range/IceStake/IceStake.tscn")
var rolling_pin = preload("res://Objects/Spells/Melee/RollingPin/RollingPin.tscn")
var rock_1 = preload("res://Objects/Spells/Range/Rock/TheRock.tscn")
var rock_2 = preload("res://Objects/Spells/Range/Rock/TheRock2.tscn")
var rock_3 = preload("res://Objects/Spells/Range/Rock/TheRock3.tscn")
var rock_4 = preload("res://Objects/Spells/Range/Rock/TheRock4.tscn")
var rock_5 = preload("res://Objects/Spells/Range/Rock/TheRock5.tscn")

var wizards_spells : Dictionary = {1:[], 2:[]}

var spell_list : Array = [ice_stake, rolling_pin, rock_1, rock_2, rock_3, rock_4, rock_5]
var init_instanced_spells : Array = []
var selection_pool_spells : Array = []

func _ready():
	_initialize_spells()
	#_add_wizards_test_spells()
	pass

func _initialize_spells():
	for spell_scene in spell_list:
		var spell_instance : Spell = spell_scene.instance()
		spell_instance.set_spell_id(init_instanced_spells.size())
		init_instanced_spells.append(spell_instance)
		selection_pool_spells.append(spell_instance)
	pass

func _add_wizards_test_spells():
	add_wizard_spell(1, init_instanced_spells[2])
	add_wizard_spell(1, init_instanced_spells[1])
	add_wizard_spell(2, init_instanced_spells[1])
	add_wizard_spell(2, init_instanced_spells[2])
	pass

func add_wizard_spell(wizard_id : int, spell_instance : Spell):
	var spell = spell_instance.duplicate()
	spell.initialize(wizard_id)
	wizards_spells[wizard_id].append(spell)
	pass

func get_wizard_spells(player_id : int):
	if player_id == -1: return
	return wizards_spells[player_id]

func get_selection_spells():
	var selection_spells : Array = []
	for i in range(3):
		selection_spells.append(get_new_random_spell())
	return selection_spells

func get_new_random_spell():
	randomize()
	var new_spell_idx = rand_range(0, selection_pool_spells.size())
	var new_spell = selection_pool_spells[new_spell_idx]
	selection_pool_spells.erase(new_spell)
	return new_spell
