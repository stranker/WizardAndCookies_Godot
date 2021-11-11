extends Node

enum Scenes { 
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
		Scenes.MAIN_MENU:
			scene_name = "res://Scenes/MainMenu.tscn"
		Scenes.CHARACTER_SELECTION:
			scene_name = "res://Scenes/CharacterSelection.tscn"
		Scenes.GAMEPLAY:
			scene_name = "res://Scenes/Gameplay.tscn"
		Scenes.POST_GAME:
			scene_name = "res://Scenes/PostGame.tscn"
	var _current_scene = get_tree().change_scene(scene_name)
	pass
