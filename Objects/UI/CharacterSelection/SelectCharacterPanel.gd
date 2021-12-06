extends Control

class_name SelectCharacterPanel

signal on_wizard_selected(selected)

onready var background : TextureRect = $Background
onready var waiting_for_player_panel : Control = $WaitingForPlayerPanel
onready var selected_character_panel : Control = $SelectCharacterPanel
onready var highlight : TextureRect  = $Highlight
onready var player_id_label : Label  = $SelectCharacterPanel/PlayerId
onready var name_label : Label = $SelectCharacterPanel/PlayerSelectArrow/HBC/Name
onready var portrait : TextureRect   = $SelectCharacterPanel/Portrait
onready var input_type : TextureRect = $SelectCharacterPanel/InputType
onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var press_join_anim : AnimationPlayer = $WaitingForPlayerPanel/PressJoin/Anim
onready var press_join_label : Label = $WaitingForPlayerPanel/PressJoin/Button
onready var player_select_arrow_anim : AnimationPlayer = $SelectCharacterPanel/PlayerSelectArrow/Anim
onready var current_wizard_id : int = 0
onready var current_wizard : WizardData = wizards_data[current_wizard_id]

onready var select : String
onready var back : String
onready var move_left : String
onready var move_right : String

export var player_id : int = -1
export var waiting_for_player : bool
export var wizard_selected : bool = false
export (Array, Resource) var wizards_data
export (Array, Texture) var panel_textures
export var gamepad_texture : Texture
export var keyboard_texture : Texture

var is_using_gamepad : bool


func _ready() -> void:
	background.texture = panel_textures[randi() % panel_textures.size()]
	press_join_label.text = "A" if GameManager.has_xinput_controller() else "X"
	pass

func _input(event):
	if (waiting_for_player || wizard_selected):
		return
	if event is InputEventJoypadButton or event is InputEventKey:
		if (event.is_action_pressed(move_left)):
			move_trough_wizards_array(false)
		elif (event.is_action_pressed(move_right)):
			move_trough_wizards_array(true)
		elif (event.is_action_pressed(select)):
			wizard_selected = true
			animation_player.play("OnAccept")
		elif (event.is_action_pressed(back)):
			wizard_selected = false
			on_wizard_selected()
	pass

func on_wizard_selected() -> void:
	emit_signal("on_wizard_selected", wizard_selected)
	pass

func set_panel_status(value : bool, new_player_id : int, using_gamepad : bool) -> void:
	waiting_for_player = value
	animation_player.play("OnWaitingStart")
	press_join_anim.play("Pressed")
	player_id = new_player_id
	is_using_gamepad = using_gamepad
	update_inputs()
	update_panel()
	pass

func update_panel() -> void:
	player_id_label.text = "P" + str(player_id)
	name_label.text = current_wizard.name_string
	input_type.texture = gamepad_texture if is_using_gamepad else keyboard_texture
	portrait.texture = current_wizard.avatar
	pass

func move_trough_wizards_array(direction_up : bool) -> void:
	current_wizard_id = current_wizard_id + 1 if direction_up else current_wizard_id - 1 
	current_wizard_id = current_wizard_id % wizards_data.size()
	current_wizard = wizards_data[current_wizard_id]
	var arrow_anim = "RightClick" if direction_up else "LeftClick"
	player_select_arrow_anim.play(arrow_anim)
	update_panel()
	pass

func update_inputs() -> void:
	select = "ui_select_" + str(player_id)
	back = "ui_back_" + str(player_id)
	move_left = "move_left_" + str(player_id)
	move_right = "move_right_" + str(player_id)
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "OnWaitingStart":
		animation_player.play("OnSelectingWizard")
	pass # Replace with function body.
