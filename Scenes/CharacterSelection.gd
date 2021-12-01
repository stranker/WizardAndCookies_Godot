extends Control

onready var scene_manager : SceneManager = get_node("/root/SceneManager")
onready var back_button : TextureButton  = $BackBtn
onready var character_panels = [$SelectCharacterPanel1, $SelectCharacterPanel2]

onready var ui_select_1 : String  = "ui_select_1"
onready var ui_select_2 : String  = "ui_select_2"
onready var ui_back_1 : String  = "ui_back_1"
onready var ui_back_2 : String  = "ui_back_2"

var player_1_panel : int = -1
var player_2_panel : int = -1
var player_selecting_panels = [player_1_panel, player_2_panel]

var current_players : int = 0
var players_accepted : int = 0

func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed(ui_select_1)):
		add_player(1)
	elif (event.is_action_pressed(ui_select_2)):
		add_player(2)
	elif (event.is_action_pressed(ui_back_1)):
		remove_player(1)
	elif (event.is_action_pressed(ui_back_2)):
		remove_player(2)
	pass

func add_player(player_id:int) -> void:
	if (current_players < 2 and player_selecting_panels[player_id - 1] == -1):
		for i in range(character_panels.size()):
			var character_panel = character_panels[i] as SelectCharacterPanel
			if character_panel.waiting_for_player:
				character_panel.set_panel_status(false, player_id)
				current_players += 1
				player_selecting_panels[player_id - 1] = i
				return
	pass

func remove_player(player_id:int) -> void:
	if current_players > 0:
		if player_selecting_panels[player_id - 1] != -1:
			for i in range(character_panels.size()):
				var character_panel = character_panels[i] as SelectCharacterPanel
				if !character_panel.waiting_for_player and character_panel.player_id == player_id:
					current_players -= 1
					character_panel.set_panel_status(true, player_id)
					player_selecting_panels[player_id - 1] = -1
					return
	else:
		_on_BackBtn_pressed()
	pass

func _on_GameplayBtn_pressed() -> void:
	scene_manager.change_scene(scene_manager.Scenes.LOADING_PLAYER_PRESENTATION)
	pass

func _on_BackBtn_pressed() -> void:
	scene_manager.change_scene(scene_manager.Scenes.MAIN_MENU)
	pass

func _on_SelectCharacterPanel1_on_wizard_selected(selected):
	add_players_accepted(selected)
	pass


func _on_SelectCharacterPanel2_on_wizard_selected(selected):
	add_players_accepted(selected)
	pass

func add_players_accepted(add) -> void:
	players_accepted = players_accepted + 1 if add else players_accepted - 1
	if (players_accepted == 2):
		_on_GameplayBtn_pressed()
	pass
	
