extends Node

enum Scenes { 
	MAIN_MENU,
	CHARACTER_SELECTION,
	GAMEPLAY,
	POST_GAME,
	LOADING,
	LOADING_PLAYER_PRESENTATION
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
			scene_name = "res://Scenes/GameScene.tscn"
		Scenes.POST_GAME:
			scene_name = "res://Scenes/PostGame.tscn"
		Scenes.LOADING:
			scene_name = "res://Scenes/Loading.tscn"
		Scenes.LOADING_PLAYER_PRESENTATION:
			scene_name = "res://Scenes/LoadingPlayerPresentation.tscn"
	var _current_scene = get_tree().change_scene(scene_name)
	pass
