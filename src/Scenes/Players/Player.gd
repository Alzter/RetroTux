extends KinematicBody2D

var velocity = Vector2()
var snap = false
var was_on_floor = false

onready var coyote_timer = $CoyoteTimer

const MOVE_SPEED = 40
const FRICTION = 0.8
const GRAVITY = 10
const JUMP_HEIGHT = 340

func apply_gravity(delta):
	if coyote_timer.is_stopped():
		velocity.y += GRAVITY * delta * 60
		
		if velocity.y > 0:
			snap = true

func apply_velocity():
	var snap_amount = Vector2(0, int(snap) * 32)
	
	was_on_floor = is_on_floor()
	velocity = move_and_slide_with_snap(velocity, snap_amount, Vector2(0, -1))

func move_input():
	velocity.x *= FRICTION
	var move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	if move_direction != 0:
		$AnimatedSprite.scale.x = move_direction
	velocity.x += MOVE_SPEED * move_direction
	if abs(velocity.x) < 6:
		velocity.x = 0
