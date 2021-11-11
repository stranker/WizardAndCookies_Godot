extends Node

enum SCENES { 
	MAIN_MENU,
	CHARACTER_SELECTION,
	GAMEPLAY,
	POST_GAME
}

func _ready():
	pass # Replace with function body.

func change_scene(scene):
	var scene_name = ""
	match scene:
		SCENES.MAIN_MENU:
			scene_name = "res://Scenes/MainMenu.tscn"
		SCENES.CHARACTER_SELECTION:
			scene_name = "res://Scenes/CharacterSelection.tscn"
		SCENES.GAMEPLAY:
			scene_name = "res://Scenes/Gameplay.tscn"
		SCENES.POST_GAME:
			scene_name = "res://Scenes/PostGame.tscn"
	var _current_scene = get_tree().change_scene(scene_name)
	pass
