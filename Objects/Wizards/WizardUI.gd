extends Position2D

export var debug_text : bool = true

onready var wizard : Wizard = get_parent()
onready var anchor : Control = $CanvasLayer/Anchor
onready var health_label : Label = $CanvasLayer/Anchor/Panel/VBC/Health
onready var fly_label : Label = $CanvasLayer/Anchor/Panel/VBC/FlyEnergy
onready var movement_state : Label = $CanvasLayer/Anchor/Panel/VBC/MovementState
onready var can_move_label : Label = $CanvasLayer/Anchor/Panel/VBC/CanMove
onready var attacking_state : Label = $CanvasLayer/Anchor/Panel/VBC/AttackingState
onready var effect_state : Label = $CanvasLayer/Anchor/Panel/VBC/EffectState
onready var window_size : Vector2 = get_tree().root.get_viewport().get_visible_rect().size
onready var anchor_position : Vector2 = Vector2.ZERO

func _ready():
	set_process(debug_text)
	anchor.visible = debug_text
	if debug_text:
		wizard.connect("on_state_change", self, "_on_change_state")
		wizard.connect("on_health_update", self, "_on_health_update")
		wizard.connect("on_fly_energy_update", self, "_on_fly_energy_update")
		wizard.connect("on_casting_spell", self, "_on_casting_spell")
		wizard.connect("on_invoke_spell", self, "_on_invoke_spell")
		wizard.connect("on_end_cast_spell", self, "_on_end_cast_spell")
		wizard.connect("on_can_move_update", self, "_on_can_move_update")
		wizard.connect("on_effects_update", self, "_on_effects_update")
	pass

func _process(delta):
	anchor_position.x = global_position.x
	anchor_position.y = global_position.y
	anchor.rect_position = anchor_position
	pass

func _on_health_update(health : float):
	health_label.text = str(health) + " HP"
	pass

func _on_fly_energy_update(fly_energy : float):
	fly_label.text = str(fly_energy) + " Fly"
	pass

func _on_change_state(state, state_string):
	movement_state.text = "Movement: " + state_string
	pass

func _on_casting_spell():
	attacking_state.text = "Attack: Casting"
	pass

func _on_invoke_spell():
	attacking_state.text = "Attack: Invoke"
	pass

func _on_end_cast_spell():
	attacking_state.text = "Attack: Idle"
	pass

func _on_can_move_update(can_move : bool):
	can_move_label.text = "Can move: " + ("True" if can_move else "False")
	pass

func _on_effects_update(effects : Array):
	effect_state.text = ""
	for effect in effects:
		effect_state.text += "[" + effect.get_name() + "]"
	pass
