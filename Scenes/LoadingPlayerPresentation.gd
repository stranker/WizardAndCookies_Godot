extends Control

onready var animation_player = $AnimationPlayer
onready var shake_wizards_player = $ShakeWizardsPlayer
onready var loading_bar = $VS/LoadingBar
onready var scene_manager = get_node("/root/SceneManager")

export var name_p1 : String
export var wizard_texture_p1 : Texture
export var name_p2 : String
export var wizard_texture_p2 : Texture

var timer: float = 0
var max_time: float = 100

func _ready() -> void:
	$PresentationPanel1/Holder/Name.text = name_p1
	$PresentationPanel1/Holder/WizardTexture.texture = wizard_texture_p1
	$PresentationPanel2/Holder/Name.text = name_p2
	$PresentationPanel2/Holder/WizardTexture.texture = wizard_texture_p2
	animation_player.play("PlayerPresentationShow")
	pass

func _process(delta: float) -> void:
	if timer >= max_time:
		scene_manager.change_scene(scene_manager.Scenes.GAMEPLAY)
	timer += delta * 25
	loading_bar.value = timer
	pass

func shake_wizards(shake:bool) -> void:
	if shake:
		shake_wizards_player.play("ShakeWizards")
	else:
		shake_wizards_player.stop()
	pass
