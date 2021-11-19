extends KinematicBody2D

class_name Wizard

const UP_DIRECTION : Vector2 = Vector2.UP

export var speed : float = 600.0
onready var initial_speed = speed
export var jump_strength : float = 600.0
export var gravity : float = 4500.0
export var can_move : bool = true
export var max_health : float = 10.0
onready var health : float = max_health
export var max_fly_energy : float = 100.0
onready var fly_energy : float = max_fly_energy
export var fly_energy_consume : float = 1.0
export var player_id : int = 1
export var decrease_fly : bool = false
export var get_input_available : bool = true

var velocity : Vector2 = Vector2.ZERO
var is_falling : bool = false
var is_jumping : bool = false
var is_idle : bool = false
var is_running : bool = false
var is_flying : bool = false
var is_casting : bool = false
var is_invoking : bool = false
var can_recover_fly : bool = true
var false_movement : bool = false

enum MovementState { FALLING, JUMPING, IDLE, RUNNING, FLYING, CASTING, INVOKING, LAST }
export (MovementState) var current_state = MovementState.IDLE
export (MovementState) var old_state = MovementState.IDLE
var movement_state_string = ["Falling", "Jumping", "Idle", "Running", "Flying", "Casting", "Invoking", "Last"]

onready var move_left : String = "move_left_" + str(player_id) 
onready var move_right : String = "move_right_" + str(player_id) 
onready var move_up : String = "move_up_" + str(player_id) 
onready var move_down : String = "move_down_" + str(player_id) 
onready var jump : String = "jump_" + str(player_id) 
onready var fly : String = "fly_" + str(player_id)

onready var visual : Node2D = $Visual
onready var effects_controller : Node2D = $EffectsController
onready var wizard_particles : Node2D = $Visual/WizardParticles

signal on_initialize()
signal on_state_change(state, state_string)
signal on_health_update(health)
signal on_health_depleted()
signal on_fly_energy_update(fly_energy)
signal on_fly_energy_depleted()
signal on_casting_spell()
signal on_invoke_spell()
signal on_end_cast_spell()
signal on_can_move_update(can_move)
signal on_effects_update(effects)
signal on_emit_jump_particles(emitting)
signal on_knockback(is_knockback)
signal on_pickup_effect(effect)

func _ready():
	_set_new_state(MovementState.IDLE, MovementState.IDLE)
	emit_signal("on_health_update", health)
	set_can_move(can_move)
	add_to_group("Wizard")
	emit_signal("on_initialize")
	pass

func _physics_process(delta):
	_process_flying()
	_process_movement(delta)
	_process_state_machine()
	velocity = move_and_slide(velocity, UP_DIRECTION)
	pass

func _process_state_machine():
	is_falling = velocity.y > 0 and not is_on_floor()
	is_jumping = Input.is_action_just_pressed(jump) and is_on_floor() and get_input_available
	is_idle = is_on_floor() and is_zero_approx(velocity.x)
	is_running = is_on_floor() and not is_zero_approx(velocity.x)
	is_flying = Input.is_action_pressed(fly) and fly_energy > 0 and get_input_available
	match current_state:
		MovementState.IDLE:
			if is_running:
				_set_new_state(MovementState.IDLE, MovementState.RUNNING)
			elif is_jumping:
				_set_new_state(MovementState.IDLE, MovementState.JUMPING)
			elif is_flying:
				_set_new_state(MovementState.IDLE, MovementState.FLYING)
			elif is_casting:
				_set_new_state(MovementState.IDLE, MovementState.CASTING)
		MovementState.RUNNING:
			if is_falling:
				_set_new_state(MovementState.RUNNING, MovementState.FALLING)
			elif is_idle:
				_set_new_state(MovementState.RUNNING, MovementState.IDLE)
			elif is_jumping:
				_set_new_state(MovementState.RUNNING, MovementState.JUMPING)
			elif is_flying:
				_set_new_state(MovementState.RUNNING, MovementState.FLYING)
			elif is_casting:
				_set_new_state(MovementState.RUNNING, MovementState.CASTING)
		MovementState.JUMPING:
			if is_falling:
				_set_new_state(MovementState.JUMPING, MovementState.FALLING)
			elif is_flying:
				_set_new_state(MovementState.JUMPING, MovementState.FLYING)
			elif is_casting:
				_set_new_state(MovementState.JUMPING, MovementState.CASTING)
		MovementState.FALLING:
			if is_idle:
				emit_signal("on_emit_jump_particles", true)
				_set_new_state(MovementState.FALLING, MovementState.IDLE)
			elif is_running:
				emit_signal("on_emit_jump_particles", true)
				_set_new_state(MovementState.FALLING, MovementState.RUNNING)
			elif is_flying:
				_set_new_state(MovementState.FALLING, MovementState.FLYING)
			elif is_casting:
				_set_new_state(MovementState.FALLING, MovementState.CASTING)
		MovementState.FLYING:
			if not is_flying:
				if is_falling:
					_set_new_state(MovementState.FLYING, MovementState.FALLING)
				elif is_idle:
					_set_new_state(MovementState.FLYING, MovementState.IDLE)
				elif is_running:
					_set_new_state(MovementState.FLYING, MovementState.RUNNING)
			else:
				if is_casting:
					_set_new_state(MovementState.FLYING, MovementState.CASTING)
		MovementState.CASTING:
			if not is_casting:
				if is_invoking:
					_set_new_state(MovementState.CASTING, MovementState.INVOKING)
#				elif is_falling:
#					_set_new_state(MovementState.CASTING, MovementState.FALLING)
#				elif is_idle:
#					_set_new_state(MovementState.CASTING, MovementState.IDLE)
#				elif is_running:
#					_set_new_state(MovementState.CASTING, MovementState.RUNNING)
#				elif is_flying:
#					_set_new_state(MovementState.CASTING, MovementState.FLYING)
		MovementState.INVOKING:
			if not is_invoking:
				if is_falling:
					_set_new_state(MovementState.INVOKING, MovementState.FALLING)
				elif is_idle:
					_set_new_state(MovementState.INVOKING, MovementState.IDLE)
				elif is_running:
					_set_new_state(MovementState.INVOKING, MovementState.RUNNING)
				elif is_flying:
					_set_new_state(MovementState.INVOKING, MovementState.FLYING)
	pass

func _set_new_state(old, new_state):
	old_state = old
	current_state = new_state
	if old_state != current_state:
		emit_signal("on_state_change", current_state, movement_state_string[current_state])
	pass

func _process_flying():
	if is_flying:
		if decrease_fly:
			fly_energy -= fly_energy_consume
			fly_energy = max(0, fly_energy)
			if fly_energy <= 0:
				emit_signal("on_fly_energy_depleted")
				can_recover_fly = false
	else:
		if can_recover_fly:
			fly_energy += fly_energy_consume * 2
			fly_energy = min(fly_energy, max_fly_energy)
	if fly_energy != 0 and fly_energy != max_fly_energy:
		emit_signal("on_fly_energy_update", fly_energy)
	pass

func _process_movement(delta):
	var horizontal_direction = get_horizontal_input()
	var vertical_direction = get_vertical_input()
	var dir = Vector2(horizontal_direction, vertical_direction).normalized()
	update_visual_direction(horizontal_direction)
	if !can_move: return
	if !false_movement:
		if is_flying:
			velocity.y = dir.y * speed
		else:
			velocity.y += gravity * delta
		velocity.x = dir.x * speed
	if is_jumping and not is_flying:
		velocity.y  = -jump_strength
		emit_signal("on_emit_jump_particles", true)
	pass

func update_visual_direction(horizontal):
	if visual and !is_invoking:
		if horizontal > 0.1:
			visual.scale.x = 1
		elif horizontal < -0.1:
			visual.scale.x = -1
	pass

func get_horizontal_input():
	if get_input_available:
		return Input.get_action_strength(move_right) - Input.get_action_strength(move_left)
	else:
		return 0

func get_vertical_input():
	if get_input_available:
		return Input.get_action_strength(move_down) - Input.get_action_strength(move_up)
	else:
		return 0

func get_visual_direction():
	return Vector2(visual.scale.x,0)

func take_damage(damage : float, spell_effect : Resource, knockback_force : Vector2):
	health -= damage
	health = max(0, health)
	set_knockback(knockback_force)
	if spell_effect and effects_controller:
		effects_controller.apply_effect(spell_effect)
	emit_signal("on_health_update", health)
	if(health <= 0):
		emit_signal("on_health_depleted")
	pass

func set_can_move(value : bool):
	can_move = value
	emit_signal("on_can_move_update", can_move)
	pass

func set_knockback(force : Vector2):
	set_false_movement(true, force)
	emit_signal("on_knockback", true)
	pass

func set_translate_force(force : Vector2, duration : float):
	set_false_movement(true, force)
	yield(get_tree().create_timer(duration),"timeout")
	set_false_movement(false, Vector2.ZERO)
	pass

func set_false_movement(value : bool, force : Vector2):
	false_movement = value
	velocity = force
	pass

func _on_effects_update(effects : Array):
	emit_signal("on_effects_update", effects)
	pass

func set_new_speed(new_speed : float):
	speed = new_speed
	pass

func init_speed():
	speed = initial_speed
	pass

func on_fly_energy_recover():
	can_recover_fly = true
	pass

func _on_casting_spell():
	is_casting = true
	set_can_move(false)
	velocity = move_and_slide(Vector2.ZERO)
	emit_signal("on_casting_spell")
	pass

func _on_invoke_spell():
	is_invoking = true
	is_casting = !is_invoking
	emit_signal("on_invoke_spell")
	pass

func _on_can_cast_spell():
	is_invoking = false
	set_can_move(true)
	emit_signal("on_end_cast_spell")
	pass

func get_wizard_particles():
	return wizard_particles

func _on_knockback_recover():
	false_movement = false
	pass

func pick_effect(effect : Resource):
	emit_signal("on_pickup_effect", effect)
	pass
