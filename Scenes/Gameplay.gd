extends Control

onready var scene_manager : SceneManager = get_node("/root/SceneManager")
onready var post_game_button : TextureButton = $PostGameBtn

func _ready() -> void:
	post_game_button.grab_focus()
	pass

func _on_PostGameBtn_pressed() -> void:
	scene_manager.change_scene(scene_manager.Scenes.POST_GAME)
	pass
