extends Control

onready var name_label : Label = $Name
onready var portrait  : TextureRect = $Portrait
onready var highlight : TextureRect = $Highlight

export var name_text : String
export var portrait_URL : Texture
export var player_color : Color

func _ready() -> void:
	highlight.visible = false
	name_label.text = name_text
	portrait.texture = portrait_URL
	highlight.modulate = player_color
	pass

func _on_TextureButton_focus_entered() -> void:
	highlight.visible = true
	pass

func _on_TextureButton_focus_exited() -> void:
	highlight.visible = false
	pass
