extends Camera2D

export var min_position : Vector2
export var max_position : Vector2
export var min_zoom : float = 0.8
export var max_zoom : float = 1.2
export var zoom_factor : float = 1.2

onready var viewport_size = get_viewport_rect().size

var players : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	players = get_tree().get_nodes_in_group("Wizard")
	pass # Replace with function body.

func _physics_process(delta):
	_process_movement(delta)
	_process_zoom(delta)
	pass

func _get_center_players():
	var pos : Vector2 = Vector2.ZERO
	for player in players:
		pos += player.global_position
	return pos / float(players.size())

func _process_movement(delta):
	global_position = _get_center_players()
	global_position.x = clamp(global_position.x, min_position.x, max_position.x)
	global_position.y = clamp(global_position.y, min_position.y, max_position.y)
	pass

func _get_zoom_players():
	var dist : float = 0
	for player in players:
		var player_pos : Vector2 = player.global_position
		for player_to in players:
			var player_to_pos : Vector2 = player_to.global_position
			dist += player_pos.distance_to(player_to_pos)
	return dist / viewport_size.x * zoom_factor

func _process_zoom(delta):
	zoom = lerp(zoom, Vector2.ONE * _get_zoom_players(), delta)
	zoom.x = clamp(zoom.x, min_zoom, max_zoom)
	zoom.y = clamp(zoom.y, min_zoom, max_zoom)
	pass
