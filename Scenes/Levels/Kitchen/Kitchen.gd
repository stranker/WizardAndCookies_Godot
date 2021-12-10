extends Node2D

onready var spawn_positions : Array = $SpawnPositions.get_children()


func set_wizards_position(wizards : Array):
	for i in range(wizards.size()):
		wizards[i].global_position = spawn_positions[i].global_position
	pass
