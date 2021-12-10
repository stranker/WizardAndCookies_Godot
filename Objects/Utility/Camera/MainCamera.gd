extends Camera2D

class_name MainCamera

export var min_position : Vector2
export var max_position : Vector2
export var min_zoom : float = 1.0
export var max_zoom : float = 1.2
export var zoom_factor : float = 1.20
export var zoom_speed : float = 0.5
export var max_dist_between_players : float = 2000

onready var viewport_size = get_viewport_rect().size
onready var timer : Timer = $Timer

var players : Array = []
var is_shaking : bool = false

var shake_amount : float = 0
var shake_duration : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.main_camera = self
	set_physics_process(false)
	pass # Replace with function body.

func _physics_process(delta):
	_process_movement(delta)
	_process_zoom(delta)
	_process_shake(delta)
	pass

func _get_center_players():
	var pos : Vector2 = Vector2.ZERO
	for player in players:
		pos += player.global_position
	return pos / float(players.size())

func _process_movement(delta):
	if _get_player_dist() > max_dist_between_players: return
	global_position = lerp(global_position, _get_center_players(), delta * 2.5)
	global_position.x = clamp(global_position.x, min_position.x, max_position.x)
	global_position.y = clamp(global_position.y, min_position.y, max_position.y)
	pass

func _get_player_dist():
	var dist : float = 0
	for player in players:
		var player_pos : Vector2 = player.global_position
		for player_to in players:
			var player_to_pos : Vector2 = player_to.global_position
			dist += player_pos.distance_to(player_to_pos)
	return dist

func _get_zoom_players():
	return _get_player_dist() / viewport_size.x * zoom_factor

func _process_zoom(delta):
	zoom = lerp(zoom, Vector2.ONE * _get_zoom_players(), zoom_speed)
	zoom.x = clamp(zoom.x, min_zoom, max_zoom)
	zoom.y = clamp(zoom.y, min_zoom, max_zoom)
	pass

func set_camera_shake(amount : float, duration : float):
	is_shaking = true
	shake_amount = amount
	shake_duration = duration
	timer.wait_time = shake_duration
	timer.start()
	pass

func _process_shake(delta):
	if !is_shaking: return
	offset += Vector2(rand_range(-shake_amount, shake_amount),rand_range(-shake_amount, shake_amount))
	pass

func _on_Timer_timeout():
	is_shaking = false
	offset = Vector2.ZERO
	pass # Replace with function body.


func _on_GameScene_on_wizards_created():
	players = get_tree().get_nodes_in_group("Wizard")
	set_physics_process(true)
	pass # Replace with function body.
