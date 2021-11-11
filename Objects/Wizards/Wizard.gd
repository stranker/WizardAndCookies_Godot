extends KinematicBody2D

class_name Wizard

const UP_DIRECTION : Vector2 = Vector2.UP

export var speed : float = 600.0
export var maximum_jumps : int = 2
export var jump_strength : float = 600.0
export var gravity : float = 4500.0
export var can_move : bool = true
export var max_health : float = 10.0
export var player_id : int = 1
onready var health : float = max_health

var velocity : Vector2 = Vector2.ZERO
var is_falling : bool = false
var is_jumping : bool = false
var is_idle : bool = false
var is_running : bool = false
var is_flying : bool = false

enum MovementState { FALLING, JUMPING, IDLE, RUNNING, FLYING, LAST }
export var current_state = MovementState.IDLE
var movement_state_string = ["Falling", "Jumping", "Idle", "Running", "Flying", "Last"]

onready var move_left : String = "move_left_" + str(player_id) 
onready var move_right : String = "move_right_" + str(player_id) 
onready var move_up : String = "move_up_" + str(player_id) 
onready var move_down : String = "move_down_" + str(player_id) 
onready var jump : String = "jump_" + str(player_id) 
onready var fly : String = "fly_" + str(player_id) 

signal on_state_change(state_string)
signal on_health_update(health)
signal on_health_depleted()

func _ready():
	_set_new_state(MovementState.IDLE, MovementState.IDLE)
	emit_signal("on_health_update", health)
	pass

func _physics_process(delta):
	_process_movement(delta)
	_process_state_machine()

	if is_jumping and not is_flying:
		velocity.y  = -jump_strength
	
	velocity = move_and_slide(velocity, UP_DIRECTION)
	pass

func _process_state_machine():
	is_falling = velocity.y > 0 and not is_on_floor()
	is_jumping = Input.is_action_just_pressed(jump) and is_on_floor()
	is_idle = is_on_floor() and is_zero_approx(velocity.x)
	is_running = is_on_floor() and not is_zero_approx(velocity.x)
	is_flying = Input.is_action_pressed(fly)
	match current_state:
		MovementState.IDLE:
			if is_running:
				_set_new_state(MovementState.IDLE, MovementState.RUNNING)
			elif is_jumping:
				_set_new_state(MovementState.IDLE, MovementState.JUMPING)
			elif is_flying:
				_set_new_state(MovementState.JUMPING, MovementState.FLYING)
		MovementState.RUNNING:
			if is_falling:
				_set_new_state(MovementState.RUNNING, MovementState.FALLING)
			elif is_idle:
				_set_new_state(MovementState.RUNNING, MovementState.IDLE)
			elif is_jumping:
				_set_new_state(MovementState.RUNNING, MovementState.JUMPING)
			elif is_flying:
				_set_new_state(MovementState.JUMPING, MovementState.FLYING)
		MovementState.JUMPING:
			if is_falling:
				_set_new_state(MovementState.JUMPING, MovementState.FALLING)
			elif is_flying:
				_set_new_state(MovementState.JUMPING, MovementState.FLYING)
		MovementState.FALLING:
			if is_idle:
				_set_new_state(MovementState.FALLING, MovementState.IDLE)
			elif is_flying:
				_set_new_state(MovementState.JUMPING, MovementState.FLYING)
		MovementState.FLYING:
			if is_falling and not is_flying:
				_set_new_state(MovementState.FLYING, MovementState.FALLING)
			elif is_idle and not is_flying:
				_set_new_state(MovementState.RUNNING, MovementState.IDLE)
	pass

func _set_new_state(old_state, new_state):
	current_state = new_state
	emit_signal("on_state_change", movement_state_string[current_state])
	pass

func _process_movement(delta):
	if !can_move: return
	var horizontal_direction = get_horizontal_input()
	var vertical_direction = get_vertical_input()
	velocity.x = horizontal_direction * speed
	if is_flying:
		velocity.y = vertical_direction * speed
	else:
		velocity.y += gravity * delta
	pass

func get_horizontal_input():
	return Input.get_action_strength(move_right) - Input.get_action_strength(move_left)

func get_vertical_input():
	return Input.get_action_strength(move_down) - Input.get_action_strength(move_up)

func take_damage(damage : float):
	health -= damage
	health = max(0, health)
	emit_signal("on_health_update", health)
	if(health <= 0):
		emit_signal("on_health_depleted")
	pass
