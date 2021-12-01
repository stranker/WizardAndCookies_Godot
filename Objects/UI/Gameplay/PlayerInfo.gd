extends Control

onready var hp_bar   : TextureProgress = $ProgressBars/HpBar
onready var fly_bar : TextureProgress = $ProgressBars/FlyBar
onready var character_portrait : TextureRect = $PotraitHolder/Background/Mask/Portrait
onready var spells : Array = $SpellsHolder/SpellsContainer.get_children()

export var hp : int
export var mana : int
export var character_portrait_texture : Texture
export (Array, Texture) var spells_texture

func _ready() -> void:
	hp_bar.value = hp
	fly_bar.value = mana
	character_portrait.texture = character_portrait_texture
	for i in range(spells.size()):
		spells[i].set_spell_texture(spells_texture[i])
	pass
