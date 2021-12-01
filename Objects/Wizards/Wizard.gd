extends KinematicBody2D

class_name Wizard

const UP_DIRECTION : Vector2 = Vector2.UP
const min_running_velocity : int = 10

export var speed : float = 600.0
onready var initial_speed = speed
export var fly_speed : float = 800.0
onready var initial_fly_speed : float = fly_speed
export var jump_strength : float = 600.0
export var gravity : float = 4500.0
export var hit_gravity : float = 3000.0
export var can_move : bool = true
export var max_health : float = 10.0
onready var health : float = max_health
export var max_fly_energy : float = 100.0
onready var fly_energy : float = max_fly_energy
export var fly_energy_consume : float = 1.0
export var fly_energy_dash_consume : float = 25.0
export var player_id : int = 1
export var decrease_fly : bool = false
export var get_input_available : bool = true
export var restart_position_on_exit : bool = true
export var shake_curve : Curve = null
export var knockback_time : float = 0.15

var velocity : Vector2 = Vector2.ZERO
var is_falling : bool = false
var is_jumping : bool = false
var is_idle : bool = false
var is_running : bool = false
var is_flying : bool = false
var is_casting : bool = false
var is_invoking : bool = false
var is_damaged : bool = false
var is_dashing : bool = false
var can_recover_fly : bool = true
var false_movement : bool = false

enum MovementState { FALLING, JUMPING, IDLE, RUNNING, FLYING, CASTING, INVOKING, HIT}
export (MovementState) var current_state = MovementState.IDLE
export (MovementState) var old_state = MovementState.IDLE
var movement_state_string = ["Falling", "Jumping", "Idle", "Running", "Flying", "Casting", "Invoking", "Hit"]

onready var move_left : String = "move_left_" + str(player_id) 
onready var move_right : String = "move_right_" + str(player_id) 
onready var move_up : String = "move_up_" + str(player_id) 
onready var move_down : String = "move_down_" + str(player_id) 
onready var jump : String = "jump_" + str(player_id) 
onready var fly : String = "fly_" + str(player_id)

onready var visual : Node2D = $Visual
onready var effects_controller : Node2D = $EffectsController
onready var wizard_particles : Node2D = $Visual/WizardParticles

onready var initial_pos : Vector2 = global_position

signal on_initialize()
signal on_state_change(state, state_string)
signal on_health_update(health)
signal on_health_depleted()
signal on_fly_energy_update(fly_energy)
signal on_fly_energy_depleted()
signal on_flying(is_flying)
signal on_dashing()
signal on_casting_spell()
signal on_invoke_spell()
signal on_end_cast_spell()
signal on_can_move_update(can_move)
signal on_effects_update(effects)
signal on_emit_jump_particles(emitting)
signal on_knockback(is_knockback)
signal on_knockback_recover()
signal on_pickup_effect(effect)

func _ready():
	_set_new_state(MovementState.IDLE, MovementState.IDLE)
	emit_signal("on_health_update", health)
	set_can_move(can_move)
	add_to_group("Wizard")
	emit_signal("on_initialize")
	pass

func _physics_process(delta):
	_process_flying(delta)
	_process_movement(delta)
	_process_state_machine()
	move_and_slide(velocity, UP_DIRECTION)
	pass

func _process_state_machine():
	is_falling = velocity.y > 0 and not is_on_floor()
	is_jumping = Input.is_action_just_pressed(jump) and is_on_floor() and get_input_available
	is_idle = is_on_floor() and abs(velocity.x) <= min_running_velocity
	is_running = is_on_floor() and abs(velocity.x) > min_running_velocity
	is_flying = Input.is_action_pressed(fly) and fly_energy > 0 and get_input_available
	is_dashing = is_flying and Input.is_action_just_pressed(jump)
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
			elif is_damaged:
				_set_new_state(MovementState.IDLE, MovementState.HIT)
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
			elif is_damaged:
				_set_new_state(MovementState.RUNNING, MovementState.HIT)
		MovementState.JUMPING:
			emit_signal("on_emit_jump_particles", true)
			if is_falling:
				_set_new_state(MovementState.JUMPING, MovementState.FALLING)
			elif is_flying:
				_set_new_state(MovementState.JUMPING, MovementState.FLYING)
			elif is_casting:
				_set_new_state(MovementState.JUMPING, MovementState.CASTING)
			elif is_damaged:
				_set_new_state(MovementState.JUMPING, MovementState.HIT)
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
			elif is_damaged:
				_set_new_state(MovementState.FALLING, MovementState.HIT)
		MovementState.FLYING:
			if not is_flying:
				if is_falling:
					_set_new_state(MovementState.FLYING, MovementState.FALLING)
				elif is_idle:
					_set_new_state(MovementState.FLYING, MovementState.IDLE)
				elif is_running:
					_set_new_state(MovementState.FLYING, MovementState.RUNNING)
				elif is_damaged:
					_set_new_state(MovementState.FLYING, MovementState.HIT)
				elif is_casting:
					_set_new_state(MovementState.FLYING, MovementState.CASTING)
			else:
				if is_casting:
					_set_new_state(MovementState.FLYING, MovementState.CASTING)
				elif is_damaged:
					_set_new_state(MovementState.FLYING, MovementState.HIT)
		MovementState.CASTING:
			if not is_casting:
				if is_invoking:
					_set_new_state(MovementState.CASTING, MovementState.INVOKING)
			elif is_damaged:
				_set_new_state(MovementState.CASTING, MovementState.HIT)
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
				elif is_damaged:
					_set_new_state(MovementState.INVOKING, MovementState.HIT)
		MovementState.HIT:
			if not is_damaged:
				if is_falling:
					_set_new_state(MovementState.HIT, MovementState.FALLING)
				elif is_idle:
					_set_new_state(MovementState.HIT, MovementState.IDLE)
				elif is_running:
					_set_new_state(MovementState.HIT, MovementState.RUNNING)
				elif is_flying:
					_set_new_state(MovementState.HIT, MovementState.FLYING)
	pass

func _set_new_state(old, new_state):
	old_state = old
	current_state = new_state
	if old_state != current_state:
		emit_signal("on_state_change", current_state, movement_state_string[current_state])
		if current_state == MovementState.FLYING:
			emit_signal("on_flying", true)
		elif old_state == MovementState.FLYING:
			emit_signal("on_flying", false)
	pass

func _process_flying(delta):
	if false_movement: return
	if is_flying:
		if decrease_fly:
			fly_energy -= fly_energy_consume * delta
			fly_energy = max(0, fly_energy)
			if fly_energy <= 0:
				emit_signal("on_fly_energy_depleted")
				can_recover_fly = false
	else:
		if can_recover_fly and is_on_floor():
			fly_energy += fly_energy_consume * delta
			fly_energy = min(fly_energy, max_fly_energy)
	if fly_energy != max_fly_energy:
		emit_signal("on_fly_energy_update", fly_energy)
	pass

func _process_movement(delta):
	var movement_direction : Vector2 = Vector2.ZERO
	var horizontal_direction = get_horizontal_input()
	var vertical_direction = get_vertical_input()
	update_visual_direction(horizontal_direction)
	if can_move:
		movement_direction = Vector2(horizontal_direction, vertical_direction).normalized()
		if !false_movement:
			if is_flying:
				velocity = movement_direction * fly_speed
			else:
				if movement_direction.length() > 0:
					velocity.x = movement_direction.x * speed
				else:
					velocity.x = lerp(velocity.x, 0, delta * min_running_velocity)
				if !is_on_floor():
					_apply_gravity(gravity, delta)
				else:
					velocity.y = 0
		if is_jumping and not is_flying:
			velocity.y = -jump_strength
		if is_dashing:
			_dash(movement_direction)
	else:
		if is_damaged:
			_apply_gravity(hit_gravity, delta)
	pass

func _apply_gravity(_gravity : float, delta : float):
	velocity.y += _gravity * delta
	pass

func _dash(dir : Vector2):
	if dir != Vector2.ZERO:
		set_translate_force(dir * fly_speed * 2.5, 0.1)
	else:
		set_translate_force(get_visual_direction() * fly_speed * 2.5, 0.1)
	emit_signal("on_dashing")
	fly_energy -= fly_energy_dash_consume
	fly_energy = max(0, fly_energy)
	pass

func update_visual_direction(horizontal):
	if visual and !false_movement:
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

func take_damage(damage : float, spell_effect : Resource, knockback_force : Vector2, spell_position : Vector2):
	is_damaged = true
	health -= damage
	health = max(0, health)
	emit_signal("on_health_update", health)
	if(health <= 0):
		emit_signal("on_health_depleted")
	var shake_force = shake_curve.interpolate(1 - (health / float(max_health))) * damage
	GameManager.main_camera.set_camera_shake(shake_force, 0.5)
	if spell_effect and effects_controller:
		effects_controller.apply_effect(spell_effect)
	set_knockback(knockback_force, spell_position)
	pass

func set_can_move(value : bool):
	can_move = value
	emit_signal("on_can_move_update", can_move)
	pass

func set_knockback(force : Vector2, enemy_wizard_position : Vector2):
	emit_signal("on_knockback", true)
	if force == Vector2.ZERO:
		is_damaged = false
		return
	if is_on_floor() and is_zero_approx(force.x):
		var dir_x = (global_position - enemy_wizard_position).normalized().x
		force.x = dir_x * abs(force.y) * 0.5
	set_can_move(false)
	yield(get_tree().create_timer(knockback_time),"timeout")
	set_false_movement(true, force)
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

func reduce_speed(factor : float):
	speed *= factor
	fly_speed *= factor
	pass

func init_speed():
	speed = initial_speed
	fly_speed = initial_fly_speed
	pass

func on_fly_energy_recover():
	can_recover_fly = true
	pass

func _on_casting_spell():
	is_casting = true
	set_can_move(false)
	velocity = Vector2.ZERO
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
	set_can_move(true)
	false_movement = false
	is_damaged = false
	emit_signal("on_knockback_recover")
	pass

func pick_effect(effect : Resource):
	emit_signal("on_pickup_effect", effect)
	pass

func _on_VisibilityNotifier2D_screen_exited():
	if !restart_position_on_exit: return
	restart_position()
	pass # Replace with function body.

func restart_position():
	global_position = initial_pos
	pass
