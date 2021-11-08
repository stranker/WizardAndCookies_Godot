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

enum MovementState { FALLING, JUMPING, IDLE, RUNNING, LAST }
export var current_state = MovementState.IDLE
var movement_state_string = ["Falling", "Jumping", "Idle", "Running", "Last"]

signal on_change_state(state_string)

func _ready():
	pass

func _physics_process(delta):
	_process_movement(delta)
	_process_state_machine()

	if is_jumping:
		velocity.y  = -jump_strength
	velocity = move_and_slide(velocity, UP_DIRECTION)
	pass

func _process_state_machine():
	is_falling = velocity.y > 0 and not is_on_floor()
	is_jumping = Input.is_action_just_pressed("jump") and is_on_floor()
	is_idle = is_on_floor() and is_zero_approx(velocity.x)
	is_running = is_on_floor() and not is_zero_approx(velocity.x)
	match current_state:
		MovementState.IDLE:
			if is_running:
				_set_new_state(MovementState.IDLE, MovementState.RUNNING)
			elif is_jumping:
				_set_new_state(MovementState.IDLE, MovementState.JUMPING)
		MovementState.RUNNING:
			if is_falling:
				_set_new_state(MovementState.RUNNING, MovementState.FALLING)
			elif is_idle:
				_set_new_state(MovementState.RUNNING, MovementState.IDLE)
			elif is_jumping:
				_set_new_state(MovementState.RUNNING, MovementState.JUMPING)
		MovementState.JUMPING:
			if is_falling:
				_set_new_state(MovementState.JUMPING, MovementState.FALLING)
		MovementState.FALLING:
			if is_idle:
				_set_new_state(MovementState.FALLING, MovementState.IDLE)
	pass

func _set_new_state(old_state, new_state):
	current_state = new_state
	emit_signal("on_change_state", movement_state_string[current_state])
	pass

func _process_movement(delta):
	if !can_move: return
	var horizontal_direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.x = horizontal_direction * speed
	velocity.y += gravity * delta
	pass
