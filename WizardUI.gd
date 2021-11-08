extends CanvasLayer

onready var anchor : Control = $Anchor
onready var player_state : Label = $Anchor/PlayerState
onready var wizard_position : Vector2 = get_parent().global_position
onready var state_position : Position2D = get_parent().get_node("StatePosition")

onready var window_size = get_tree().root.get_viewport().get_visible_rect().size

func _on_change_state(state):
	pass

func _process(delta):
	wizard_position.x = int(state_position.global_position.x) % int(window_size.x)
	wizard_position.y = int(state_position.global_position.y) % int(window_size.y)
	anchor.rect_position = wizard_position
	pass

func _on_Zak_on_change_state(state):
	player_state.text = state
	pass # Replace with function body.
