extends Control

enum States { NORMAL, FOCUSED, SELECTED }

onready var name_label: Label = $Name
onready var portrait: TextureRect = $Portrait
onready var anim : AnimationPlayer = $Anim

onready var stats = $Stats
onready var stats_names = [$Stats/Stat1/Name, $Stats/Stat2/Name, $Stats/Stat3/Name]
onready var stats_bars = [$Stats/Stat1/Bar, $Stats/Stat2/Bar, $Stats/Stat3/Bar]

export var name_string: String
export var portrait_texture: Texture
export var stat_1_value: int #we could use the real stat name on the vars once we decide it
export var stat_2_value: int
export var stat_3_value: int

export (Gradient) var color_tint

var current_state = States.NORMAL

signal on_end_selected()

func _ready() -> void:
	name_label.text = name_string
	portrait.texture = portrait_texture
	set_bar_data(0, "DAMAGE", stat_1_value)
	set_bar_data(1, "RANGE", stat_2_value)
	set_bar_data(2, "COOLDOWN", stat_3_value)
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
		emit_signal("on_end_selected")
	pass

func is_selected():
	return current_state == States.SELECTED
