extends TextureButton

onready var label : Label = $Label
onready var anim : AnimationPlayer = $AnimationPlayer

export var text : String

func _ready() -> void:
	label.text = text;
	pass


func _on_TextureButton_button_down():
	label.rect_position.y += 8
	pass # Replace with function body.


func _on_TextureButton_button_up():
	label.rect_position.y -= 8
	pass # Replace with function body.
