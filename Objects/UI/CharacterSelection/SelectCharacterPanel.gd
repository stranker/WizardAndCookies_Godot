extends Control

class_name SelectCharacterPanel

enum PanelStates { WAITING_PLAYER, SELECTING_WIZARD, READY_UP }

onready var background : TextureRect = $Background
onready var waiting_for_player_panel : Control = $WaitingForPlayerPanel
onready var selected_character_panel : Control = $SelectCharacterPanel
onready var player_id_label : Label  = $SelectCharacterPanel/PlayerId
onready var name_label : Label = $SelectCharacterPanel/PlayerSelectArrow/HBC/Name
onready var portrait : TextureRect   = $SelectCharacterPanel/Portrait
onready var input_type : TextureRect = $SelectCharacterPanel/InputType
onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var press_join_anim : AnimationPlayer = $WaitingForPlayerPanel/PressJoin/Anim
onready var press_join_label : Label = $WaitingForPlayerPanel/PressJoin/Button
onready var player_select_arrow_anim : AnimationPlayer = $SelectCharacterPanel/PlayerSelectArrow/ArrowAnim
onready var ready_label : Label = $SelectCharacterPanel/ReadyLabel
onready var current_wizard_id : int = 0
onready var current_wizard : WizardData = null
onready var current_state = PanelStates.WAITING_PLAYER

onready var select : String
onready var back : String
onready var move_left : String
onready var move_right : String

export var player_id : int = -1
export (Array, Resource) var wizards_data
export (Array, Texture) var panel_textures
export var gamepad_texture : Texture
export var keyboard_texture : Texture

var wizards_data_duped : Array = []

signal on_wizard_selected(wizard_data)
signal on_wizard_deselected(player_id)
signal on_remove_player(player_id)

func _ready() -> void:
	background.texture = panel_textures[randi() % panel_textures.size()]
	press_join_label.text = "A" if GameManager.has_xinput_controller() else "X"
	_duplicate_wizards_data()
	pass

func _duplicate_wizards_data():
	for wizard_data in wizards_data:
		var wiz_data = wizard_data as WizardData
		var duped_data = wiz_data.duplicate()
		wizards_data_duped.append(duped_data)
	current_wizard = wizards_data_duped[current_wizard_id]
	pass

func _input(event):
	if current_state == PanelStates.WAITING_PLAYER: return
	if !event is InputEventKey and !event is InputEventJoypadButton: return
	if current_state == PanelStates.SELECTING_WIZARD:
		if (event.is_action_pressed(move_left)):
			move_trough_wizards_array(false)
		elif (event.is_action_pressed(move_right)):
			move_trough_wizards_array(true)
		elif (event.is_action_pressed(select)):
			on_wizard_selected()
	if event.is_action_pressed(back):
		_on_back_button()
	pass

func _on_back_button():
	if current_state == PanelStates.READY_UP:
		on_wizard_deselected()
	else:
		current_state = PanelStates.WAITING_PLAYER
		animation_player.play("RESET")
		emit_signal("on_remove_player", player_id)
	pass

func on_wizard_selected() -> void:
	current_state = PanelStates.READY_UP
	ready_label.visible = current_state == PanelStates.READY_UP
	animation_player.play("OnAccept")
	player_select_arrow_anim.play("OnSelect")
	current_wizard.player_id = player_id
	emit_signal("on_wizard_selected", current_wizard)
	pass

func on_wizard_deselected():
	current_state = PanelStates.SELECTING_WIZARD
	ready_label.visible = current_state == PanelStates.READY_UP
	animation_player.play("RESET")
	animation_player.queue("OnSelectingWizard")
	player_select_arrow_anim.play_backwards("OnSelect")
	emit_signal("on_wizard_deselected", player_id)
	pass

func set_panel_data(event : InputEvent) -> void:
	if player_id == -1: return
	InputManager.add_player(player_id, event)
	animation_player.play("OnWaitingStart")
	press_join_anim.play("Pressed")
	update_inputs()
	update_panel()
	pass

func reset_data():
	InputManager.remove_player(player_id)
	animation_player.play("RESET")
	press_join_anim.play("RESET")
	pass

func update_panel() -> void:
	player_id_label.text = "P" + str(player_id)
	name_label.text = current_wizard.name_string
	input_type.texture = gamepad_texture if InputManager.is_using_gamepad(player_id) else keyboard_texture
	portrait.texture = current_wizard.avatar
	pass

func move_trough_wizards_array(direction_up : bool) -> void:
	current_wizard_id = current_wizard_id + 1 if direction_up else current_wizard_id - 1 
	current_wizard_id = current_wizard_id % wizards_data_duped.size()
	current_wizard = wizards_data_duped[current_wizard_id]
	var arrow_anim = "RightClick" if direction_up else "LeftClick"
	player_select_arrow_anim.play(arrow_anim)
	update_panel()
	pass

func update_inputs() -> void:
	if player_id == -1: return
	select = "ui_select_" + str(player_id)
	back = "ui_back_" + str(player_id)
	move_left = "move_left_" + str(player_id)
	move_right = "move_right_" + str(player_id)
	pass

func is_waiting_for_player():
	return current_state == PanelStates.WAITING_PLAYER

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "OnWaitingStart":
		animation_player.play("OnSelectingWizard")
	if anim_name == "OnSelectingWizard":
		current_state = PanelStates.SELECTING_WIZARD
	pass # Replace with function body.


func _on_Anim_animation_finished(anim_name):
	if anim_name == "RESET":
		press_join_anim.play("Wait")
	pass # Replace with function body.
