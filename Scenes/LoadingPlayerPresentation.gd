extends Control

onready var animation_player = $AnimationPlayer
onready var loading_bar = $VSBar/LoadingBar
onready var name_p1 = $Panels/PresentationPanel1/Holder/Name
onready var name_p2 = $Panels/PresentationPanel2/Holder/Name
onready var wizard_avatar_p1 = $Panels/PresentationPanel1/Holder/WizardTexture
onready var wizard_avatar_p2 = $Panels/PresentationPanel2/Holder/WizardTexture
onready var right_particles = $RightParticles
onready var left_particles = $LeftParticles

var timer: float = 0
var max_time: float = 100

func _ready() -> void:
	_initialize()
	pass

func _initialize():
	if GameManager.wizards_gameplay_data.empty(): return
	var wizards_data : Array = GameManager.wizards_gameplay_data
	var wizard_1 = wizards_data[0] as WizardData
	var wizard_2 = wizards_data[1] as WizardData
	name_p1.text = wizard_1.name_string
	wizard_avatar_p1.texture = wizard_1.avatar
	name_p2.text = wizard_2.name_string
	wizard_avatar_p2.texture = wizard_2.avatar
	left_particles.process_material.color = wizard_1.wizard_base_color
	right_particles.process_material.color = wizard_2.wizard_base_color
	pass

func _process(delta: float) -> void:
	if timer >= max_time:
		SceneManager.change_scene(SceneManager.Scenes.SPELL_SELECTION)
	timer = lerp(timer, timer + rand_range(1, 20), delta)
	loading_bar.value = timer
	pass
