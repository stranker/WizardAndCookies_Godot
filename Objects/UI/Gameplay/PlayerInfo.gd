extends Control

onready var hp_bar   : TextureProgress = $ProgressBars/HpBar
onready var mana_bar : TextureProgress = $ProgressBars/ManaBar
onready var character_portrait : TextureRect = $PotraitHolder/Portrait
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
	mana_bar.value = mana
	character_portrait.texture = character_portrait_texture
	$SpellsHolder/Spell1/SpellPortrait.texture = spell1_portrait_texture
	$SpellsHolder/Spell2/SpellPortrait.texture = spell2_portrait_texture
	$SpellsHolder/Spell3/SpellPortrait.texture = spell3_portrait_texture
	pass
