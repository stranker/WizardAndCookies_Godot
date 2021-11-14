extends Control

onready var scene_manager = get_node("/root/SceneManager")
onready var main_menu_button : TextureButton = $VBoxContainer/MainMenuBtn

func _ready() -> void:
	main_menu_button.grab_focus()
	pass

func _on_RestartBtn_pressed() -> void:
	scene_manager.change_scene(scene_manager.Scenes.GAMEPLAY)
	pass


func _on_MainMenuBtn_pressed() -> void:
	scene_manager.change_scene(scene_manager.Scenes.MAIN_MENU)
	pass
