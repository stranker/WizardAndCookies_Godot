extends Node2D

export var max_effect_respawn_time : float
export var min_effect_respawn_time : float

onready var positions : Array = $Positions.get_children()
onready var effects_parent : Node2D = $Effects
onready var timer : Timer = $Timer
onready var effects_count = positions.size()

var effect_scene = preload("res://Objects/PickUps/Effect/EffectPickup.tscn")
var effect_last_positions : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = _get_random_respawn_time()
	for pos in positions:
		_spawn_effect(pos)
	pass # Replace with function body.

func _spawn_effect(pos : Position2D):
	var effect = effect_scene.instance()
	effects_parent.call_deferred("add_child", effect)
	effect.connect("on_pickup", self, "_on_effect_pickup")
	effect.call_deferred("init", pos.global_position)
	pass

func _spawn_effect_in_pos(pos : Vector2):
	var effect = effect_scene.instance()
	effects_parent.call_deferred("add_child", effect)
	effect.connect("on_pickup", self, "_on_effect_pickup")
	effect.call_deferred("init", pos)
	pass

func _get_random_position():
	var rand_num = randi() % positions.size()
	return positions[rand_num]

func _get_random_respawn_time():
	return rand_range(min_effect_respawn_time, max_effect_respawn_time)

func _on_Timer_timeout():
	var new_pos = effect_last_positions[0]
	effect_last_positions.remove(0)
	_spawn_effect_in_pos(new_pos)
	if effect_last_positions.empty(): return
	timer.wait_time = _get_random_respawn_time()
	timer.start()
	pass # Replace with function body.

func _on_effect_pickup(effect):
	effect_last_positions.push_back(effect.global_position)
	effect.queue_free()
	if !timer.is_stopped(): return
	timer.start()
	pass
