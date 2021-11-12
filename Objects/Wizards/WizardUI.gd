extends Position2D

export var debug_text : bool = true

onready var anchor : Control = $CanvasLayer/Anchor
onready var health_label : Label = $CanvasLayer/Anchor/VBC/Health
onready var movement_state : Label = $CanvasLayer/Anchor/VBC/MovementState
onready var can_move_label : Label = $CanvasLayer/Anchor/VBC/CanMove
onready var attacking_state : Label = $CanvasLayer/Anchor/VBC/AttackingState
onready var effect_state : Label = $CanvasLayer/Anchor/VBC/EffectState
onready var window_size : Vector2 = get_tree().root.get_viewport().get_visible_rect().size
onready var anchor_position : Vector2 = Vector2.ZERO

func _ready():
	set_process(debug_text)
	anchor.visible = debug_text
	if debug_text:
		get_parent().connect("on_state_change", self, "_on_change_state")
		get_parent().connect("on_health_update", self, "_on_health_update")
		get_parent().connect("on_casting_spell", self, "_on_casting_spell")
		get_parent().connect("on_can_move_update", self, "_on_can_move_update")
	pass

func _process(delta):
	anchor_position.x = int(global_position.x) % int(window_size.x)
	anchor_position.y = int(global_position.y) % int(window_size.y)
	anchor.rect_position = anchor_position
	pass

func _on_health_update(health : float):
	health_label.text = str(health) + " HP"
	pass

func _on_change_state(state):
	movement_state.text = "Movement: " + state
	pass

func _on_casting_spell(is_casting : bool):
	attacking_state.text = "Attack: " + ("Casting" if is_casting else "Idle")
	pass

func _on_can_move_update(can_move : bool):
	can_move_label.text = "Can move: " + ("True" if can_move else "False")
	pass
