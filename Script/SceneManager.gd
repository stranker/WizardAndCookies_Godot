extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum SCENES { 
	MAIN_MENU,
	CHARACTER_SELECTION,
	GAMEPLAY,
	POST_GAME
}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change_scene(scene):
	var scene_name = ""
	print(typeof(scene))
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
