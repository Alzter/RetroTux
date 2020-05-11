extends KinematicBody2D

var velocity = Vector2()
var snap = false
var was_on_floor = false

onready var coyote_timer = $CoyoteTimer
onready var jump_buffer = $JumpBuffer
onready var sprite = $AnimatedSprite
onready var camera = get_tree().current_scene.get_node("Camera2D")

const MOVE_SPEED = 40
const FRICTION = 0.8
const GRAVITY = 12
const JUMP_HEIGHT = 340

func apply_gravity(delta):
	if coyote_timer.is_stopped():
		velocity.y += GRAVITY * delta * 60
		
		if velocity.y > 0:
			snap = true

func apply_velocity():
	var snap_amount = Vector2(int(snap) * sprite.scale.x * -1, int(snap) * 5)
	print(snap_amount)
	
	was_on_floor = is_on_floor()
	velocity = move_and_slide_with_snap(velocity, snap_amount, Vector2(0, -1))

func move_input():
	velocity.x *= FRICTION
	var move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	if move_direction != 0:
		sprite.scale.x = move_direction
	velocity.x += MOVE_SPEED * move_direction
	if abs(velocity.x) < 6:
		velocity.x = 0

func camera_update():
	position.x = clamp(position.x, camera.limit_left + 8, camera.limit_right - 8)
	camera.position = position
