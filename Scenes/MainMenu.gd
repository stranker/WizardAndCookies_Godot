extends Control

onready var scene_manager   = get_node("/root/SceneManager")
onready var main_menu_panel = $MainMenuPanel
onready var settings_panel 	= $SettingsPanel
onready var animation_player = $AnimationPlayer

func _ready() -> void:
	animation_player.play("MainMenu_Show")
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
	pass


func _on_SettingsExitBtn_pressed() -> void:
	main_menu_panel.visible = true
	settings_panel.visible 	= false
	pass
