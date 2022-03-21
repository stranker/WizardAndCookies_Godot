extends Control

var spell_panel_scene = preload("res://Objects/UI/SpellSelection/SpellSelectionInfo.tscn")

onready var player_name: Label = $Name
onready var player_id: Label = $PlayerId
onready var input_timer : Timer = $InputTimer
onready var panels : HBoxContainer = $Panels

var spell_panels : Array = []

var current_panel_index : int = 0
var current_selected_panel : Control
var last_selected_panel : Control

var players_selected : int = 0

var players_pool : Array = []
var spells_pool : Array = []
var current_player : WizardData = null
var current_player_id : int = -1

var select : String
var back : String
var move_left : String
var move_right : String

var player_input_valid : bool = true

func _ready() -> void:
	initialize()
	pass

func initialize():
	if GameManager.wizards_gameplay_data.empty():
		GameManager.create_placeholder_wizards()
		InputManager.create_placeholder_inputs()
	players_pool = GameManager.get_players_by_win_rate()
	_initialize_spell_panels()
	select_next_player()
	pass

func _initialize_spell_panels():
	spells_pool = SpellManager.get_selection_spells()
	for spell in spells_pool:
		var new_panel = spell_panel_scene.instance()
		panels.add_child(new_panel)
		new_panel.connect("on_end_selected", self, "_on_end_panel_select")
		new_panel.set_spell_data(spell)
		spell_panels.append(new_panel)
	current_selected_panel = spell_panels[0]
	last_selected_panel = current_selected_panel
	pass

func _input(event) -> void:
	if !player_input_valid: return
	if !event is InputEventKey and !event is InputEventJoypadButton: return
	if (event.is_action_pressed(move_left)):
		_move_left()
	elif (event.is_action_pressed(move_right)):
		_move_right()
	elif (event.is_action_pressed(select)):
		on_select()
	pass

func update_inputs() -> void:
	select = "ui_select_" + str(current_player_id) 
	back = "ui_back_" + str(current_player_id)
	move_left = "move_left_" + str(current_player_id)
	move_right = "move_right_" + str(current_player_id)
	pass

func update_labels() -> void:
	player_name.text = current_player.name_string
	player_id.text = "PLAYER " + str(current_player_id)
	player_name.modulate = current_player.player_color
	player_id.modulate = current_player.player_color
	pass

func _move_left():
	current_panel_index -= 1
	current_panel_index = current_panel_index % spell_panels.size()
	if spell_panels[current_panel_index].is_selected():
		_move_left()
	set_selected_panel(spell_panels[current_panel_index])
	pass

func _move_right():
	current_panel_index += 1
	current_panel_index = current_panel_index % spell_panels.size()
	if spell_panels[current_panel_index].is_selected():
		_move_right()
	pass

func on_select() -> void:
	if !player_input_valid: return
	players_selected += 1
	current_selected_panel.select()
	player_input_valid = false
	input_timer.start()
	_move_right()
	pass

func set_selected_panel(new_panel) -> void:
	last_selected_panel = current_selected_panel
	current_selected_panel = new_panel

	if !last_selected_panel.is_selected():
		last_selected_panel.unfocus()
	if !current_selected_panel.is_selected():
		current_selected_panel.focus()
	pass

func select_first_available_spell() -> void:
	current_panel_index = 0
	while current_panel_index < 2:
		if spell_panels[current_panel_index].visible:
			set_selected_panel(spell_panels[current_panel_index])
			return
		current_panel_index += 1
	pass

func get_next_player():
	current_player = players_pool[players_selected]
	current_player_id = current_player.player_id
	pass

func select_next_player() -> void:
	get_next_player()
	update_inputs()
	update_labels()
	set_selected_panel(spell_panels[current_panel_index])
	pass

func _on_end_panel_select(spell):
	SpellManager.add_wizard_spell(current_player_id, spell)
	if players_selected < players_pool.size():
		select_next_player()
	else:
		player_input_valid = false
		SceneManager.change_scene(SceneManager.Scenes.GAMEPLAY)
	pass

func reset() -> void:
	pass


func _on_InputTimer_timeout():
	player_input_valid = players_selected < players_pool.size()
	pass # Replace with function body.
