extends Control

class_name SelectCharacterPanel

signal on_wizard_selected(selected)

#todo mover esto a otro lado
class WizardData:
	var player_color : Color
	var portrait_URL : String
	var name_string : String

onready var waiting_for_player_panel : Control = $WaitingForPlayerPanel
onready var selected_character_panel : Control = $SelectCharacterPanel
onready var highlight : TextureRect  = $Highlight
onready var player_id_label : Label  = $PlayerId
onready var name_label : Label = $SelectCharacterPanel/Name
onready var portrait : TextureRect   = $SelectCharacterPanel/Portrait
onready var input_type : TextureRect = $SelectCharacterPanel/InputType

onready var select : String
onready var back : String
onready var move_left : String
onready var move_right : String

export var player_id : int = -1
export var waiting_for_player : bool
export var is_using_gamepad : bool
export var wizard_selected : bool = false

var gamepad_icon_URL  : String = "res://Assets/UI/CharacterSelection/Asset_Joystick.png"
var keyboard_icon_URL : String = "res://Assets/UI/CharacterSelection/Asset_Keyboard.png"

var wizard_1 : WizardData
var wizard_2 : WizardData
var wizards_array
var current_wizard_id : int = 0
var current_wizard : WizardData

func _ready() -> void:
	reset()
	wizard_1 = WizardData.new()
	wizard_2 = WizardData.new()
	current_wizard = wizard_1
	wizards_array = [wizard_1, wizard_2]
	wizard_1.name_string = "Zak"
	wizard_2.name_string = "Meg"
	wizard_1.player_color = Color.red
	wizard_2.player_color = Color.green
	wizard_1.portrait_URL = "res://Assets/UI/CharacterSelection/Asset_ZakFace.png"
	wizard_2.portrait_URL = "res://Assets/UI/CharacterSelection/Asset_MegFace.png"
	pass

func _unhandled_input(event: InputEvent) -> void:
	if (waiting_for_player || wizard_selected):
		return

	if (event.is_action_pressed(move_left)):
		move_trough_wizards_array(false)
	elif (event.is_action_pressed(move_right)):
		move_trough_wizards_array(true)
	elif (event.is_action_pressed(select)):
		wizard_selected = true
		emit_signal("on_wizard_selected", wizard_selected)
	elif (event.is_action_pressed(back)):
		wizard_selected = false
		emit_signal("on_wizard_selected", wizard_selected)
	pass

func set_panel_status(value:bool, new_player_id:int) -> void:
	waiting_for_player = value
	waiting_for_player_panel.visible = waiting_for_player
	selected_character_panel.visible = !waiting_for_player
	player_id = new_player_id
	update_inputs()

	if (waiting_for_player):
		reset()
	else:
		update_panel()
	pass

func update_panel() -> void:
	highlight.modulate = current_wizard.player_color
	player_id_label.text = "P" + str(player_id)
	name_label.text = current_wizard.name_string
	
	var icon_URL = gamepad_icon_URL if is_using_gamepad else keyboard_icon_URL
	input_type.texture = load(icon_URL)

	portrait.texture = load(current_wizard.portrait_URL)
	pass

func move_trough_wizards_array(direction_up : bool) -> void:
	current_wizard_id = current_wizard_id + 1 if direction_up else current_wizard_id - 1 
	current_wizard_id = clamp(current_wizard_id, 0, 1) #update if we add more wizards
	current_wizard = wizards_array[current_wizard_id]
	update_panel()
	pass

func reset() -> void:
	highlight.modulate = Color.white
	name_label.text = ""
	player_id_label.text = ""
	input_type.texture = null
	portrait.texture = null
	pass
	
func update_inputs() -> void:
	select = "ui_select_" + str(player_id) 
	back = "ui_back_" + str(player_id)
	move_left = "move_left_" + str(player_id)
	move_right = "move_right_" + str(player_id)
	pass
