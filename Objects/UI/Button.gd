extends TextureButton

onready var label : Label = $Label
onready var anim : AnimationPlayer = $Anim

export var text : String

func _ready() -> void:
	label.text = text
	rect_pivot_offset = rect_size * 0.5
	pass


func _on_TextureButton_button_down():
	anim.play("Pressed")
	label.rect_position.y += 8
	pass # Replace with function body.


func _on_TextureButton_button_up():
	label.rect_position.y -= 8
	pass # Replace with function body.


func _on_TextureButton_focus_entered():
	anim.play("FocusEnter")
	pass # Replace with function body.


func _on_TextureButton_mouse_entered():
	anim.play("FocusEnter")
	pass # Replace with function body.
