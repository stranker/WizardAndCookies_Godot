extends Area2D

export (Array, Resource) var effects_data
export (SpellManager.EffectType) var debug_effect_type = SpellManager.EffectType.FIRE
export var is_random : bool = true
var init_anim : AnimationPlayer
var pick_anim : AnimationPlayer
onready var collision = $Collision
var visual_effects : Array = []
var effect : Resource = null
var picked : bool = false
var can_pick : bool = false

signal on_pickup(effect)

func _ready():
	init(global_position)
	pass

func init(pos : Vector2):
	global_position = pos
	visual_effects = [$Fire, $Ice, $Stun]
	init_anim = $InitialEffect/Anim
	pick_anim = $Anim
	_set_effect()
	pass

func _set_effect():
	effect = effects_data[randi() % SpellManager.EffectType.LAST] if is_random else effects_data[debug_effect_type]
	init_anim.play("Enter")
	pass

func _set_effect_visible():
	visual_effects[effect.e_type].get_node("AnimationPlayer").connect("animation_finished", self, "_on_effect_anim_finished")
	visual_effects[effect.e_type].get_node("AnimationPlayer").play("Start")
	pass

func _on_effect_anim_finished(anim_name):
	if anim_name == "Start":
		can_pick = true
		collision.disabled = false
	pass

func _on_EffectPickup_body_entered(body):
	if !can_pick: return
	if !body.has_method("pick_effect") and picked: return
	picked = true
	can_pick = false
	body.pick_effect(effect)
	pick_anim.play("Pickup")
	pass


func _on_Anim_animation_finished(anim_name):
	if anim_name == "Pickup":
		emit_signal("on_pickup", self)
	pass # Replace with function body.
