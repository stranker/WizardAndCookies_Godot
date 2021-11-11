extends Control

onready var SceneManager = get_node("/root/SceneManager")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_GotoPostGameBtn_pressed():
	SceneManager.change_scene(SceneManager.SCENES.POST_GAME)
	pass # Replace with function body.
