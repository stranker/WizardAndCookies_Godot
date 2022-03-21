extends Spell

class_name RangeSpell

export var speed : float = 600.0
var velocity : Vector2

func _ready():
	_create_destroy_timer()
	pass

func _create_destroy_timer():
	var destroy_timer : Timer = Timer.new()
	add_child(destroy_timer)
	destroy_timer.wait_time = 7
	destroy_timer.connect("timeout", self, "_on_destroy_timer_timeout")
	destroy_timer.start()
	pass

func _on_destroy_timer_timeout():
	call_deferred("queue_free")
	pass

func cast(spell_position : Position2D, spell_direction : Vector2, effect : Resource):
	.cast(spell_position, spell_direction, effect)
	velocity = direction * speed
	rotation = atan2(direction.y, direction.x)
	pass

func _physics_process(delta):
	translate(velocity * delta)
	pass
