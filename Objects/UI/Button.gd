extends TextureButton

export var text:String

onready var label = $Label

func _ready() -> void:
	label.text = text;
	pass
