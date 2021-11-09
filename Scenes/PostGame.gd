extends Control

onready var SceneManager = get_node("/root/SceneManager")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_RestartBtn_pressed():
	SceneManager.change_scene(SceneManager.SCENES.GAMEPLAY)
	pass # Replace with function body.


func _on_MainMenuBtn_pressed():
	SceneManager.change_scene(SceneManager.SCENES.MAIN_MENU)
	pass # Replace with function body.
