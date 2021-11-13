extends Control

onready var waiting_for_player_panel = $WaitingForPlayerPanel
onready var selected_character_panel = $SelectCharacterPanel
onready var highlight = $Highlight
onready var player_id_label = $PlayerId
onready var portrait = $SelectCharacterPanel/Portrait
onready var input_type = $SelectCharacterPanel/InputType

export var waiting_for_player : bool
export var player_color : Color
export var player_id : int
export var is_using_gamepad : bool

var zak_portrait_URL  : String = "res://Assets/UI/CharacterSelection/Asset_ZakFace.png"
var meg_portrait_URL  : String = "res://Assets/UI/CharacterSelection/Asset_MegFace.png"
var gamepad_icon_URL  : String = "res://Assets/UI/CharacterSelection/Asset_Joystick.png"
var keyboard_icon_URL : String = "res://Assets/UI/CharacterSelection/Asset_Keyboard.png"

func _process(delta: float) -> void:
	waiting_for_player_panel.visible = true  if waiting_for_player else false
	selected_character_panel.visible = false if waiting_for_player else true
	highlight.modulate = player_color
	player_id_label.text = "P" + str(player_id)
	
	var icon_URL = gamepad_icon_URL if is_using_gamepad else keyboard_icon_URL
	input_type.texture = load(icon_URL)
	
	match player_id:
		1:
			portrait.texture = load(zak_portrait_URL)
		2:
			portrait.texture = load(meg_portrait_URL)
	pass
