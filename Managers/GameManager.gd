extends Node

enum SpellType { RANGE, MELEE }
enum EffectType { FIRE, ICE, STUN }

var main_camera : MainCamera = null

var wizards : Dictionary = {1:null, 2:null}

func get_wizard_by_id(id):
	return wizards[id]

func add_wizard(wizard):
	wizards[wizard.player_id] = wizard
	pass
