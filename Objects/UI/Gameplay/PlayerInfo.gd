extends Control

export var player_id : int = 0
export var character_portrait_texture : Texture

onready var hp_bar : TextureProgress = $ProgressBars/HpBar
onready var fly_bar : TextureProgress = $ProgressBars/FlyBar
onready var character_portrait : TextureRect = $PotraitHolder/Background/Portrait
onready var spells : Array = $SpellsHolder/SpellsContainer.get_children()
onready var anim_hp_bar : AnimationPlayer = $ProgressBars/HpBar/Anim
onready var anim_fly_bar : AnimationPlayer = $ProgressBars/FlyBar/Anim
onready var tween : Tween = $Tween

var wizard : Wizard = null

signal on_cooldown_end(spell_idx)

func _ready() -> void:
	if player_id <= 0 and player_id > GameManager.wizards.size(): return
	set_wizard(GameManager.get_wizard_by_id(player_id))
	pass

func set_wizard(_wizard : Wizard):
	wizard = _wizard
	if !wizard: return
	fly_bar.max_value = wizard.max_fly_energy
	fly_bar.value = fly_bar.max_value
	hp_bar.max_value = wizard.max_health
	hp_bar.value = hp_bar.max_value
	var wizard_spells : Array = SpellManager.get_wizard_spells(wizard.player_id)
	if !wizard_spells.empty():
		for i in range(wizard_spells.size()):
			spells[i].set_spell(wizard_spells[i])
			spells[i].connect("on_cooldown_end", self, "_on_cooldown_end")
	wizard.connect("on_fly_energy_update", self, "_on_fly_update")
	wizard.connect("on_health_update", self, "_on_health_update")
	wizard.connect("on_invoke_spell", self, "_on_invoke_spell")
	connect("on_cooldown_end", wizard, "_on_cooldown_end")
	character_portrait.texture = wizard.head_icon
	pass

func _on_fly_update(fly_energy):
	var do_fullfly = fly_bar.value < ceil(fly_energy)
	fly_bar.value = ceil(fly_energy)
	if fly_energy / float(fly_bar.max_value) <= 0.3:
		anim_fly_bar.play("LowFly")
	elif fly_energy / float(fly_bar.max_value) > 0.3 and ceil(fly_energy) < fly_bar.max_value:
		anim_fly_bar.play("RESET")
	elif ceil(fly_energy) >= fly_bar.max_value and do_fullfly:
		anim_fly_bar.play("FullFly")
	pass

func tween_health(init, end):
	tween.stop_all()
	tween.remove_all()
	tween.interpolate_property(hp_bar, "value", init, end, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	pass

func _on_health_update(health):
	var damage = hp_bar.value - health
	tween_health(hp_bar.value, health)
	if health / float(hp_bar.max_value) <= 0.3:
		anim_hp_bar.play("LowHp")
	elif health < hp_bar.max_value:
		anim_hp_bar.play("Hit")
	elif health == hp_bar.max_value:
		anim_hp_bar.play("RESET")
	pass

func _on_invoke_spell(spell : Spell, _spell_idx : int):
	for wizard_spell in spells:
		if wizard_spell.spell:
			if wizard_spell.get_spell_name() == spell.get_name():
				wizard_spell.start_cooldown(_spell_idx)
	pass

func _on_cooldown_end(spell_idx):
	emit_signal("on_cooldown_end", spell_idx)
	pass
