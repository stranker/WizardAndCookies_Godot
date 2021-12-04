extends Control

onready var player_name: Label = $Name
onready var player_id: Label = $PlayerId

export var player_name_string: String
export var player_id_value: String

onready var select : String
onready var back : String
onready var move_left : String
onready var move_right : String

onready var spell_panels = [$HBoxContainer/SpellSelectionInfo1, $HBoxContainer/SpellSelectionInfo2, $HBoxContainer/SpellSelectionInfo3]
export (Array, Resource) var wizards_data

onready var current_wizard_id : int = 1
onready var current_wizard : WizardData = wizards_data[current_wizard_id]

var current_panel_index : int = 0
onready var current_selected_panel : Control = spell_panels[0]
onready var last_selected_panel : Control = spell_panels[0]

var players_selected : int = 0

func _ready() -> void:
	current_selected_panel.show_highlight(true)
	select_next_player()
	pass
	
func _input(event) -> void:
	if event is InputEventKey:
		if (event.is_action_pressed(move_left)):
			move_to_panel(false)
		elif (event.is_action_pressed(move_right)):
			move_to_panel(true)
		elif (event.is_action_pressed(select)):
			on_select()
	pass

func update_inputs() -> void:
	select = "ui_select_" + str(current_wizard.device_id + 1) 
	back = "ui_back_" + str(current_wizard.device_id + 1)
	move_left = "move_left_" + str(current_wizard.device_id + 1)
	move_right = "move_right_" + str(current_wizard.device_id + 1)
	pass

func update_labels() -> void:
	player_name.text = current_wizard.name_string
	player_id.text = "PLAYER " + str(current_wizard.device_id + 1)

	player_name.modulate = current_wizard.player_color
	player_id.modulate = current_wizard.player_color
	pass

func move_to_panel(direction : int) -> void:
	if direction == 1:
		while current_panel_index < 2:
			current_panel_index += 1
			if spell_panels[current_panel_index].visible:
				set_selected_panel(spell_panels[current_panel_index])
				return
	elif direction == 0:
		while current_panel_index > 0:
			current_panel_index -= 1
			if spell_panels[current_panel_index].visible:
				set_selected_panel(spell_panels[current_panel_index])
				return
	pass

func on_select() -> void:
	players_selected += 1
	current_selected_panel.visible = false
	if players_selected >= 2:
		print("todo volver a gameplay")
		return
	select_first_available_spell()
	select_next_player()
	pass

func set_selected_panel(new_panel) -> void:
	last_selected_panel = current_selected_panel
	current_selected_panel = new_panel

	last_selected_panel.show_highlight(false)
	current_selected_panel.show_highlight(true)
	pass

func select_first_available_spell() -> void:
	current_panel_index = 0
	while current_panel_index < 2:
		if spell_panels[current_panel_index].visible:
			set_selected_panel(spell_panels[current_panel_index])
			return
		current_panel_index += 1
	pass

func select_next_player() -> void:
	current_wizard_id = 0 if current_wizard_id == 1 else 1
	current_wizard = wizards_data[current_wizard_id]
	update_inputs()
	update_labels()
	pass

func reset() -> void:
	pass

