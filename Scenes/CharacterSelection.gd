extends Control

onready var scene_manager : SceneManager = get_node("/root/SceneManager")
onready var back_button : TextureButton  = $BackBtn

func _ready() -> void:
	back_button.grab_focus()
	pass

func _on_GameplayBtn_pressed() -> void:
	scene_manager.change_scene(scene_manager.Scenes.LOADING_PLAYER_PRESENTATION)
	pass

func _on_BackBtn_pressed() -> void:
	scene_manager.change_scene(scene_manager.Scenes.MAIN_MENU)
	pass
