extends Resource
class_name SpellData

export (String) var s_name
# Float slider-min  max   step
export (float, 0.0, 10.0, 0.5) var s_damage
export (float, 0.0, 10.0, 0.5) var s_cooldown
export (float, 0.0, 10.0, 0.5) var s_range
export (float, 0.0, 5.0 , 0.5) var s_difficulty
export (SpellManager.SpellType) var s_type = SpellManager.SpellType.LAST

signal on_hit(target)
