extends TextureButton

onready var label : Label = $Label

export var text : String

func _ready() -> void:
	label.text = text;
	pass
