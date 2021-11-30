extends Node2D

export var max_effect_respawn_time : float
export var min_effect_respawn_time : float
export var max_effects_count : int = 1

onready var positions : Array = $Positions.get_children()
onready var effects_parent : Node2D = $Effects
onready var timer : Timer = $Timer
onready var effects_count : int = max_effects_count

var effect_scene = preload("res://Objects/PickUps/Effect/EffectPickup.tscn")
var effect_last_positions : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = _get_random_respawn_time()
	for pos in positions:
		_spawn_effect(pos)
	pass # Replace with function body.

func _spawn_effect(pos : Position2D):
	if effects_count <= 0: return
	var effect = effect_scene.instance()
	pos.call_deferred("add_child", effect)
	effect.connect("on_pickup", self, "_on_effect_pickup")
	effect.call_deferred("init", pos.global_position)
	effects_count -= 1
	pass

func _get_random_position():
	var rand_num = randi() % positions.size()
	var rand_pos : Position2D = positions[rand_num]
	if rand_pos.get_children().empty():
		return rand_pos
	else:
		rand_num = (rand_num + 1) % positions.size()
		return positions[rand_num]
	return 

func _get_random_respawn_time():
	return rand_range(min_effect_respawn_time, max_effect_respawn_time)

func _on_Timer_timeout():
	var new_pos = _get_random_position()
	_spawn_effect(new_pos)
	timer.wait_time = _get_random_respawn_time()
	timer.start()
	pass

func _on_effect_pickup(effect):
	effects_count += 1
	effect.call_deferred("queue_free")
	if !timer.is_stopped(): return
	timer.start()
	pass
