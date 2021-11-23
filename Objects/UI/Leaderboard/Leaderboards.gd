extends Control

onready var player_1_name: Label = $Panel/Row1/Name
onready var player_2_name: Label = $Panel/Row2/Name
onready var player_2_portrait: TextureRect = $Panel/Row2/Portrait
onready var player_1_portrait: TextureRect = $Panel/Row1/Portrait
onready var player_1_cookies = [$Panel/Row1/CookieLeaderboard1, $Panel/Row1/CookieLeaderboard2, $Panel/Row1/CookieLeaderboard3]
onready var player_2_cookies = [$Panel/Row2/CookieLeaderboard1, $Panel/Row2/CookieLeaderboard2, $Panel/Row2/CookieLeaderboard3]

export var player_1_points: int = 0
export var player_2_points: int = 0
export var player_1_name_string: String
export var player_2_name_string: String
export var player_1_portrait_texture: Texture;
export var player_2_portrait_texture: Texture;

func _ready() -> void:
	player_1_portrait.texture = player_1_portrait_texture
	player_2_portrait.texture = player_2_portrait_texture
	player_1_name.text = player_1_name_string
	player_2_name.text = player_2_name_string
	reset()
	show_leaderboard(true, 0)
	pass

func show_leaderboard(winner: bool, id: int) -> void:
	for i in range (player_1_points):
		show_cookie(true, player_1_cookies[i] as CookieLeaderboard)
	for i in range (player_2_points):
		show_cookie(true, player_2_cookies[i] as CookieLeaderboard)
		
	if winner:
		if id == 0:
			player_1_points += 1
			anim_cookie(player_1_cookies[player_1_points - 1] as CookieLeaderboard)
		elif id == 1:
			player_2_points += 1
			anim_cookie(player_2_cookies[player_2_points - 1] as CookieLeaderboard)

func reset():
	for i in range(3):
		show_cookie(false, player_1_cookies[i] as CookieLeaderboard)
		show_cookie(false, player_2_cookies[i] as CookieLeaderboard)
	pass

func show_cookie(show: bool, cookie: CookieLeaderboard):
	cookie.show_cookie(show)
	pass

func anim_cookie(cookie: CookieLeaderboard):
	cookie.anim_cookie()
	pass
