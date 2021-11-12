extends Resource
class_name SpellEffect

export (String) var e_name
# Float slider-min  max   step
export (float, 0.0, 10.0, 0.5) var e_damage
export (float, 0.0, 10.0, 0.5) var e_time
export (int, 1, 10, 1) var e_repeat_count
export (SpellManager.EffectType) var e_type = SpellManager.EffectType.LAST
