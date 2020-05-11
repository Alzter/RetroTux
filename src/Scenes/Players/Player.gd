extends KinematicBody2D

var velocity = Vector2()
var snap = false
var jumping = false

const MOVE_SPEED = 40
const FRICTION = 0.8
const GRAVITY = 24
const JUMP_HEIGHT = 600

func _input(event):
	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = -JUMP_HEIGHT
		snap = false
	if is_on_floor():
		print("OK")

func apply_gravity(delta):
	velocity.y += GRAVITY * delta * 60
	
	if velocity.y > 0:
		snap = true

func apply_velocity():
	var snap_amount = Vector2(0, int(snap) * 32)
	velocity = move_and_slide_with_snap(velocity, snap_amount, Vector2(0, -1))

func move_input():
	velocity.x *= FRICTION
	var move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	velocity.x += MOVE_SPEED * move_direction
	if abs(velocity.x) < 6:
		velocity.x = 0
