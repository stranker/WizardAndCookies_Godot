extends Node

enum SpellType { RANGE, MELEE }
enum EffectType { FIRE, ICE, STUN }

var main_camera : MainCamera = null
var wizards : Dictionary = {1:null, 2:null}
var joypads_connected : Array = []
var wizards_gameplay_data : Array = []

func _ready():
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	joypads_connected = Input.get_connected_joypads()
	pass

func has_xinput_controller():
	var x_input : bool = false
	for joy_pad_id in joypads_connected:
		if Input.get_joy_name(joy_pad_id).find("XInput") >= 0:
			x_input = true
	return x_input

func _on_joy_connection_changed(device_id : int, connected : bool):
	if connected:
		print(Input.get_joy_name(device_id))
	else:
		print("KEYBOARD")
	pass

func get_wizard_by_id(id):
	return wizards[id]

func add_wizard(wizard):
	wizards[wizard.player_id] = wizard
	pass

func set_wizards_data_for_gameplay(wizards_data : Array):
	wizards_gameplay_data = wizards_data
	pass
