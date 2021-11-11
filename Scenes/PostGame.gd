extends Control

onready var scene_manager = get_node("/root/SceneManager")

func _on_RestartBtn_pressed() -> void:
	scene_manager.change_scene(scene_manager.Scenes.GAMEPLAY)
	pass


func _on_MainMenuBtn_pressed() -> void:
	scene_manager.change_scene(scene_manager.Scenes.MAIN_MENU)
	pass
