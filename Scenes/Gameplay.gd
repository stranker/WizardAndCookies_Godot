extends Control

onready var post_game_button : TextureButton   = $PostGameBtn
onready var viewport_size 	 : Vector2 		   = get_viewport_rect().size
onready var main_camera 	 : MainCamera 	   = GameManager.main_camera
onready var players_info 	 : Array 		   = $HUDMC/PlayersInfo.get_children()
onready var hud_mc			 : MarginContainer = $HUDMC
onready var pause_mc 		 : Control 		   = $PauseMC
onready var resume_btn		 : TextureButton   = $PauseMC/ResumeBtn

var wizards : Array = []

func _ready() -> void:
	post_game_button.grab_focus()
	wizards = get_tree().get_nodes_in_group("Wizard")
	pass

func _input(event):
	if not event is InputEventJoypadButton and not event is InputEventKey: return
	if event.is_action_pressed("pause") and !event.is_echo():
		on_pause()
	pass

func _process(_delta):
	var count = 0
	for wizard in wizards:
		if wizard.global_position.y > main_camera.global_position.y + 200:
			count += 1
	modulate.a = 0.5 if count > 0 else 1.0
	pass

func _on_PostGameBtn_pressed() -> void:
	SceneManager.change_scene(SceneManager.Scenes.POST_GAME)
	pass

func _on_MainMenuBtn_pressed():
	SceneManager.change_scene(SceneManager.Scenes.MAIN_MENU)
	pass

func on_pause() -> void:
	#pause time here
	hud_mc.visible = false
	pause_mc.visible = true
	resume_btn.grab_focus()
	pass

func _on_ResumeBtn_pressed():
	hud_mc.visible = true
	pause_mc.visible = false
	pass
