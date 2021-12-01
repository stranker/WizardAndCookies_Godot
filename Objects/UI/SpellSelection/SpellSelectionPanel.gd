extends Control

onready var player_name: Label = $Name
onready var player_id: Label = $PlayerId

export var player_name_string: String
export var player_id_value: String

func _ready() -> void:
	player_name.text = player_name_string
	player_id.text = "PLAYER" + player_id_value
	pass
