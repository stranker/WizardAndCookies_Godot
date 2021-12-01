extends Control

onready var hp_bar   : TextureProgress = $ProgressBars/HpBar
onready var fly_bar : TextureProgress = $ProgressBars/FlyBar
onready var character_portrait : TextureRect = $PotraitHolder/Background/Mask/Portrait
onready var Spell1 : Control = $SpellsHolder/Spell1
onready var Spell2 : Control = $SpellsHolder/Spell2
onready var Spell3 : Control = $SpellsHolder/Spell3

export var hp : int
export var mana : int
export var character_portrait_texture : Texture
export var spell1_portrait_texture : Texture
export var spell2_portrait_texture : Texture
export var spell3_portrait_texture : Texture

func _ready() -> void:
	hp_bar.value = hp
	fly_bar.value = mana
	character_portrait.texture = character_portrait_texture
	$SpellsHolder/HBoxContainer/Spell1/SpellPortrait.texture = spell1_portrait_texture
	$SpellsHolder/HBoxContainer/Spell2/SpellPortrait.texture = spell2_portrait_texture
	$SpellsHolder/HBoxContainer/Spell3/SpellPortrait.texture = spell3_portrait_texture
	pass
