extends Control

onready var SceneManager = get_node("/root/SceneManager")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_GotoGameplayBtn_pressed():
	print(SceneManager.SCENES.GAMEPLAY)
	SceneManager.change_scene(SceneManager.SCENES.GAMEPLAY)
	pass # Replace with function body.
