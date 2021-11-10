extends Node

var test_map = "res://Scenes/TestMap.tscn"
var main_menu = "res://Scenes/MainMenu.tscn"

func change_scene():
	get_tree().change_scene(test_map)
	pass
