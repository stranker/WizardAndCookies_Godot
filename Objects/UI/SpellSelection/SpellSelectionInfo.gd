extends Control

onready var name_label: Label = $Name
onready var portrait: TextureRect = $Portrait

onready var stats_names = [$Stat1/Name, $Stat2/Name, $Stat3/Name]
onready var stats_bars = [$Stat1/Bar, $Stat2/Bar, $Stat3/Bar]
onready var highlight = $Highlight


export var name_string: String
export var portrait_texture: Texture
export var stat_1_value: int #we could use the real stat name on the vars once we decide it
export var stat_2_value: int
export var stat_3_value: int

func _ready() -> void:
	show_highlight(false)
	name_label.text = name_string
	portrait.texture = portrait_texture
	set_bar_data(0, "DAMAGE", stat_1_value)
	set_bar_data(1, "RANGE", stat_2_value)
	set_bar_data(2, "COOLDOWN", stat_3_value)
	pass

func set_bar_data(id:int, string:String, value:int) -> void:
	var name: Label = (stats_names[id] as Label)
	var bar: TextureProgress = (stats_bars[id] as TextureProgress)
	name.text = string
	bar.value = value
	bar.tint_progress = get_color_treshold(value)
	pass

func get_color_treshold(value:int) -> Color:
	var new_color: Color
	if (value) < 4:
		new_color = Color.red
	elif (value) > 7:
		new_color = Color.green
	else:
		new_color = Color.yellow
	return new_color
	pass

func focus_entered () -> void:
	show_highlight(true)
	pass

func focus_exited () -> void:
	show_highlight(false)
	pass

func show_highlight(value)  -> void:
	highlight.visible = value
	pass
