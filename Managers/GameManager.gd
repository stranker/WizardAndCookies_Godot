extends Node

var main_camera : MainCamera = null
var wizards : Dictionary = {1:null, 2:null}
var joypads_connected : Array = []

var zak_wizard_data : Resource = load("res://Objects/UI/CharacterSelection/ZakData.tres")
var meg_wizard_data : Resource = load("res://Objects/UI/CharacterSelection/MegData.tres")
var wizards_initial_data = [zak_wizard_data, meg_wizard_data]

var wizards_gameplay_data : Array = []

func _ready():
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	joypads_connected = Input.get_connected_joypads()
	pass

func has_xinput_controller():
	for joy_pad_id in joypads_connected:
		if Input.get_joy_name(joy_pad_id).find("XInput") >= 0:
			return true
	return false

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

func set_gameplay_wizards_data(wizards_data : Array):
	wizards_gameplay_data = wizards_data
	for wizard in wizards_gameplay_data:
		add_wizard(wizard)
	pass

func create_placeholder_wizards():
	var id = 1
	for wizard in wizards_initial_data:
		wizard.player_id = id
		id += 1
	set_gameplay_wizards_data(wizards_initial_data)
	pass

func get_loser_wizard():
	if wizards_gameplay_data.empty(): return null
	var win_count : int = wizards_gameplay_data[0].win_count
	var ret_wizard : WizardData = wizards_gameplay_data[0]
	for wizard in wizards_gameplay_data:
		if wizard.win_count < win_count:
			ret_wizard = wizard
			win_count = wizard.win_count
	return ret_wizard

func get_players_by_win_rate():
	if wizards_gameplay_data.empty(): return []
	var wizards_sorted : Array = wizards_gameplay_data
	wizards_sorted.sort_custom(self, "sort_by_win_rate")
	return wizards_sorted

func sort_by_win_rate(w1 : WizardData , w2 : WizardData):
	return w1.win_count < w2.win_count
