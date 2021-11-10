extends KinematicBody2D

const UP_DIRECTION : Vector2 = Vector2.UP

export var speed : float = 600.0
export var maximum_jumps : int = 2
export var jump_strength : float = 600.0
export var gravity : float = 4500.0
export var can_move : bool = true

var velocity : Vector2 = Vector2.ZERO
var is_falling : bool = false
var is_jumping : bool = false
var is_idle : bool = false
var is_running : bool = false
var is_flying : bool = false

enum MovementState { FALLING, JUMPING, IDLE, RUNNING, FLYING, LAST }
export var current_state = MovementState.IDLE
var movement_state_string = ["Falling", "Jumping", "Idle", "Running", "Flying", "Last"]

signal on_change_state(state_string)

func _ready():
	pass

func _physics_process(delta):
	_process_movement(delta)
	_process_state_machine()

	if is_jumping and not is_flying:
		velocity.y  = -jump_strength
	velocity = move_and_slide(velocity.normalized() * speed, UP_DIRECTION)
	pass

func _process_state_machine():
	is_falling = velocity.y > 0 and not is_on_floor()
	is_jumping = Input.is_action_just_pressed("jump") and is_on_floor()
	is_idle = is_on_floor() and is_zero_approx(velocity.x)
	is_running = is_on_floor() and not is_zero_approx(velocity.x)
	is_flying = Input.is_action_pressed("fly")
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
	emit_signal("on_change_state", movement_state_string[current_state])
	pass

func _process_movement(delta):
	if !can_move: return
	var horizontal_direction = (Input.get_action_strength("move_right") - 
								Input.get_action_strength("move_left"))
	var vertical_direction = (Input.get_action_strength("move_down") - 
								Input.get_action_strength("move_up"))
	velocity.x = horizontal_direction
	if is_flying:
		velocity.y = vertical_direction
	else:
		velocity.y += gravity * delta
	pass
