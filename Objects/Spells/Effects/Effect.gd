extends Node2D

class_name Effect

var effect_name : String
var effect_duration : float
var effect_damage : float
var effect_repeat_count : int
var effect_type = GameManager.EffectType.ICE
var target : Wizard = null

onready var timer : Timer = $Duration

signal effect_end(effect)

func initialize(effect_data : SpellEffect, wizard : Wizard):
	effect_name = effect_data.e_name
	effect_duration = effect_data.e_time
	effect_damage = effect_data.e_damage
	effect_repeat_count = effect_data.e_repeat_count
	effect_type = effect_data.e_type
	timer.wait_time = effect_duration
	timer.start()
	target = wizard
	_apply_effect()
	pass

func get_name():
	return effect_name

func get_duration():
	return effect_duration

func get_damage():
	return effect_damage

func get_type():
	return effect_type


func _on_Duration_timeout():
	effect_repeat_count -= 1
	if effect_repeat_count > 0:
		_apply_effect()
		timer.start()
	else:
		emit_signal("effect_end", self)
	pass

func _apply_effect():
	match effect_type:
		GameManager.EffectType.ICE:
			_apply_ice()
		GameManager.EffectType.FIRE:
			_apply_fire()
		GameManager.EffectType.STUN:
			_apply_stun()
	pass

func _apply_fire():
	target.take_damage(effect_damage, null, Vector2(), Vector2())
	pass

func _apply_ice():
	target.reduce_speed(0.3)
	pass

func _apply_stun():
	target.set_can_move(false)
	pass
