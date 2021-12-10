extends Control

onready var scene_manager 	 	 : SceneManager    = get_node("/root/SceneManager")
onready var main_menu_panel  	 : Control 	 	   = $MainMenuPanel
onready var settings_panel 	 	 : Control  	   = $SettingsPanel
onready var credits_panel	 	 : Control		   = $CreditsPanel
onready var animation_player 	 : AnimationPlayer = $AnimationPlayer
onready var play_button 	 	 : TextureButton   = $MainMenuPanel/VBoxContainer/PlayBtn
onready var settings_back_button : TextureButton   = $SettingsPanel/VBoxContainer/SettingsBackBtn
onready var credits_back_button  : TextureButton   = $CreditsPanel/CreditsBackBtn

func _ready() -> void:
	InputManager.clear_player_input()
	animation_player.play("MainMenu_Show")
	play_button.grab_focus()
	pass

func _on_PlayBtn_pressed() -> void:
	scene_manager.change_scene(scene_manager.Scenes.CHARACTER_SELECTION)
	pass

func _on_ExitBtn_pressed() -> void:
	get_tree().quit()
	pass

func _on_SettingsBtn_pressed() -> void:
	main_menu_panel.visible = false
	settings_panel.visible 	= true
	credits_panel.visible = false
	settings_back_button.grab_focus()
	pass

func _on_SettingsBackBtn_pressed():
	main_menu_panel.visible = true
	settings_panel.visible 	= false
	credits_panel.visible = false
	play_button.grab_focus()
	pass

func _on_CreditsBtn_pressed():
	main_menu_panel.visible = false
	settings_panel.visible 	= false
	credits_panel.visible = true
	credits_back_button.grab_focus()
	pass

func _on_CreditsBackBtn_pressed():
	main_menu_panel.visible = false
	settings_panel.visible 	= true
	credits_panel.visible = false
	settings_back_button.grab_focus()
	pass
