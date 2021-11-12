extends HSlider

export var audio_bus_name := "Master"
onready var bus := AudioServer.get_bus_index(audio_bus_name)

func _ready() -> void:
	value = db2linear(AudioServer.get_bus_volume_db(bus))
	pass

func _on_VolumeSlider_value_changed(value) -> void:
	AudioServer.set_bus_volume_db(bus, linear2db(value))
	pass
