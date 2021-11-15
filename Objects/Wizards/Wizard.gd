extends KinematicBody2D

class_name Wizard

const UP_DIRECTION : Vector2 = Vector2.UP

export var speed : float = 600.0
onready var initial_speed = speed
export var maximum_jumps : int = 2
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

var velocity : Vector2 = Vector2.ZERO
var is_falling : bool = false
var is_jumping : bool = false
var is_idle : bool = false
var is_running : bool = false
var is_flying : bool = false
var can_recover_fly : bool = true

enum MovementState { FALLING, JUMPING, IDLE, RUNNING, FLYING, LAST }
export (MovementState) var current_state = MovementState.IDLE
var movement_state_string = ["Falling", "Jumping", "Idle", "Running", "Flying", "Last"]

onready var move_left : String = "move_left_" + str(player_id) 
onready var move_right : String = "move_right_" + str(player_id) 
onready var move_up : String = "move_up_" + str(player_id) 
onready var move_down : String = "move_down_" + str(player_id) 
onready var jump : String = "jump_" + str(player_id) 
onready var fly : String = "fly_" + str(player_id)

onready var visual : Node2D = $Visual
onready var spell_timer : Timer = $SpellTimer
onready var effects : Node2D = $EffectsController
onready var depleted_fly_recover : Timer = $DepletedFlyRecover
onready var wizard_skin : Node2D = $Visual/WizardSkin
onready var jump_particles_l : Particles2D = $Visual/JumpParticlesL
onready var jump_particles_r : Particles2D = $Visual/JumpParticlesR

signal on_state_change(state_string)
signal on_health_update(health)
signal on_health_depleted()
signal on_fly_energy_update(fly_energy)
signal on_fly_energy_depleted()
signal on_casting_spell(is_casting)
signal on_can_move_update(can_move)
signal on_effects_update(effects)

func _ready():
	_set_new_state(MovementState.IDLE, MovementState.IDLE)
	emit_signal("on_health_update", health)
	set_can_move(can_move)
	pass

func _physics_process(delta):
	_process_flying()
	_process_movement(delta)
	_process_state_machine()
	velocity = move_and_slide(velocity, UP_DIRECTION)
	pass

func _process_state_machine():
	is_falling = velocity.y > 0 and not is_on_floor()
	is_jumping = Input.is_action_just_pressed(jump) and is_on_floor()
	is_idle = is_on_floor() and is_zero_approx(velocity.x)
	is_running = is_on_floor() and not is_zero_approx(velocity.x)
	is_flying = Input.is_action_pressed(fly) and fly_energy > 0
	match current_state:
		MovementState.IDLE:
			if is_running:
				_set_new_state(MovementState.IDLE, MovementState.RUNNING)
			elif is_jumping:
				_set_new_state(MovementState.IDLE, MovementState.JUMPING)
			elif is_flying:
				_set_new_state(MovementState.IDLE, MovementState.FLYING)
		MovementState.RUNNING:
			if is_falling:
				_set_new_state(MovementState.RUNNING, MovementState.FALLING)
			elif is_idle:
				_set_new_state(MovementState.RUNNING, MovementState.IDLE)
			elif is_jumping:
				_set_new_state(MovementState.RUNNING, MovementState.JUMPING)
			elif is_flying:
				_set_new_state(MovementState.RUNNING, MovementState.FLYING)
		MovementState.JUMPING:
			if is_falling:
				_set_new_state(MovementState.JUMPING, MovementState.FALLING)
			elif is_flying:
				_set_new_state(MovementState.JUMPING, MovementState.FLYING)
		MovementState.FALLING:
			if is_idle:
				_set_jump_particles_emitting(true)
				_set_new_state(MovementState.FALLING, MovementState.IDLE)
			elif is_running:
				_set_jump_particles_emitting(true)
				_set_new_state(MovementState.FALLING, MovementState.RUNNING)
			elif is_flying:
				_set_new_state(MovementState.FALLING, MovementState.FLYING)
		MovementState.FLYING:
			if is_falling and not is_flying:
				_set_new_state(MovementState.FLYING, MovementState.FALLING)
			elif is_idle and not is_flying:
				_set_new_state(MovementState.FLYING, MovementState.IDLE)
			elif is_running and not is_flying:
				_set_new_state(MovementState.FLYING, MovementState.RUNNING)
	if wizard_skin:
		wizard_skin.set_state(current_state)
	pass

func _set_new_state(old_state, new_state):
	current_state = new_state
	emit_signal("on_state_change", movement_state_string[current_state])
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
	if is_flying:
		velocity.y = dir.y * speed
	else:
		velocity.y += gravity * delta
	velocity.x = dir.x * speed
	if is_jumping and not is_flying:
		velocity.y  = -jump_strength
		_set_jump_particles_emitting(true)
	pass

func update_visual_direction(horizontal):
	if visual:
		if horizontal > 0.1:
			visual.scale.x = 1
		elif horizontal < -0.1:
			visual.scale.x = -1
	pass

func get_horizontal_input():
	return Input.get_action_strength(move_right) - Input.get_action_strength(move_left)

func get_vertical_input():
	return Input.get_action_strength(move_down) - Input.get_action_strength(move_up)

func get_visual_direction():
	return Vector2(visual.scale.x,0)

func _on_SpellCast_on_casting_spell(is_casting):
	set_can_move(false)
	velocity = Vector2.ZERO
	emit_signal("on_casting_spell", is_casting)
	if !is_casting:
		spell_timer.start()
	pass # Replace with function body.


func _on_SpellTimer_timeout():
	set_can_move(true)
	pass # Replace with function body.

func take_damage(damage : float, spell_effects : Array):
	health -= damage
	health = max(0, health)
	if !spell_effects.empty() and effects:
		effects.apply_effects(spell_effects)
	emit_signal("on_health_update", health)
	if(health <= 0):
		emit_signal("on_health_depleted")
	pass

func set_can_move(value : bool):
	can_move = value
	emit_signal("on_can_move_update", can_move)
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

func _set_jump_particles_emitting(value : bool):
	jump_particles_l.emitting = value
	jump_particles_r.emitting = value
	pass

func _on_DepletedFlyRecover_timeout():
	can_recover_fly = true
	pass # Replace with function body.


func _on_Zak_on_fly_energy_depleted():
	depleted_fly_recover.start()
	pass # Replace with function body.
