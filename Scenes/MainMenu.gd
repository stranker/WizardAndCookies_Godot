extends Control

onready var SceneManager = get_node("/root/SceneManager")
onready var MainMenuPanel = $MarginContainer/MainMenuPanel
onready var SettingsPanel = $MarginContainer/SettingsPanel

func _on_PlayBtn_pressed():
	SceneManager.change_scene(SceneManager.SCENES.CHARACTER_SELECTION)
	pass

func _on_ExitBtn_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_SettingsBtn_pressed():
	MainMenuPanel.visible = false
	SettingsPanel.visible = true
	pass # Replace with function body.


func _on_SettingsExitBtn_pressed():
	MainMenuPanel.visible = true
	SettingsPanel.visible = false
	pass # Replace with function body.
