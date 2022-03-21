extends Control

enum States { NORMAL, FOCUSED, SELECTED }
var current_state = States.NORMAL

onready var name_label: Label = $Name
onready var portrait: TextureRect = $Portrait
onready var anim : AnimationPlayer = $Anim

onready var stats = $Stats
onready var stats_names = [$Stats/Stat1/Name, $Stats/Stat2/Name, $Stats/Stat3/Name]
onready var stats_bars = [$Stats/Stat1/Bar, $Stats/Stat2/Bar, $Stats/Stat3/Bar]

export (Gradient) var color_tint
var spell_instance = null

signal on_end_selected(spell)

func set_spell_data(spell):
	spell_instance = spell
	name_label.text = spell_instance.get_name()
	portrait.texture = spell_instance.get_icon()
	set_bar_data(0, "DAMAGE", spell_instance.get_damage())
	set_bar_data(1, "RANGE", spell_instance.get_type())
	set_bar_data(2, "COOLDOWN", spell_instance.get_cooldown())
	pass

func set_bar_data(id:int, string:String, value:int) -> void:
	stats_names[id].text = string
	stats_bars[id].value = value
	stats_bars[id].tint_progress = color_tint.interpolate(stats_bars[id].value / float(stats_bars[id].max_value))
	pass

func focus():
	current_state = States.FOCUSED
	anim.play("Focused")
	pass

func unfocus():
	current_state = States.NORMAL
	anim.play("Normal")
	pass

func select():
	current_state = States.SELECTED
	anim.play("Selected")
	pass

func _on_Anim_animation_finished(anim_name):
	if anim_name == "Selected":
		emit_signal("on_end_selected", spell_instance)
	pass

func is_selected():
	return current_state == States.SELECTED
