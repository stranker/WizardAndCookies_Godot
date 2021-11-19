extends Control
class_name CookieLeaderboard

onready var animation_player = $AnimationPlayer
onready var cookie_texture: TextureRect = $CookieTexture
onready var empty_texture: TextureRect = $EmptyTexture

func show_cookie(show: bool) -> void:
	cookie_texture.visible = show
	empty_texture.visible = !show
	pass

func anim_cookie() -> void:
	show_cookie(true)
	animation_player.play("ShowCookie")
	pass
