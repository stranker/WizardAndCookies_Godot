extends Control

onready var scene_manager = get_node("/root/SceneManager")

func _on_GameplayBtn_pressed() -> void:
	scene_manager.change_scene(scene_manager.Scenes.GAMEPLAY)
	pass
