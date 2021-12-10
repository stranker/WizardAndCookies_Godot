extends Control

onready var post_game_button : TextureButton = $PostGameBtn
onready var viewport_size : Vector2 = get_viewport_rect().size
onready var main_camera : MainCamera = GameManager.main_camera
onready var players_info : Array = $MC/PlayersInfo.get_children()

var wizards : Array = []

func _ready() -> void:
	set_process(false)
	pass

func _process(delta):
	var count = 0
	for wizard in wizards:
		if wizard.global_position.y > main_camera.global_position.y + 200:
			count += 1
	modulate.a = 0.5 if count > 0 else 1.0
	pass

func _on_PostGameBtn_pressed() -> void:
	SceneManager.change_scene(SceneManager.Scenes.POST_GAME)
	pass


func _on_GameScene_on_wizards_created():
	wizards = get_tree().get_nodes_in_group("Wizard")
	for player_info in players_info:
		player_info.init()
	set_process(true)
	pass # Replace with function body.
