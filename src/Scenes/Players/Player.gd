extends KinematicBody2D

var velocity = Vector2()
var snap = false
var was_on_floor = false
var offset = 0
var camera_offset = 0

onready var coyote_timer = $CoyoteTimer
onready var jump_buffer = $JumpBuffer
onready var sprite = $AnimatedSprite
onready var camera = get_tree().current_scene.get_node("Camera2D")

const CAMERA_OFFSET = 32
const WALK_SPEED = 1.5 * 16
const RUN_SPEED = 2.5 * 16
const FRICTION = 0.8

var gravity = 10 * 60
var jump_height = 4.5 * 16
var jump_height_max = 5.5 * 16

func _ready():
	jump_height = sqrt(2 * gravity * jump_height)
	jump_height_max = sqrt(2 * gravity * jump_height_max)
	camera.position = position

func apply_gravity(delta):
	if coyote_timer.is_stopped():
		velocity.y += gravity * delta
		
		if velocity.y > 0:
			snap = true

func apply_velocity():
	var snap_amount = Vector2(int(snap) * int(abs(velocity.x) > 2) * sprite.scale.x * -1, int(snap) * 5)
	
	was_on_floor = is_on_floor()
	velocity = move_and_slide_with_snap(velocity, snap_amount, Vector2(0, -1))

func move_input():
	velocity.x *= FRICTION
	
	var move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	if Input.is_action_pressed("run"): velocity.x += RUN_SPEED * move_direction
	else: velocity.x += WALK_SPEED * move_direction
	if abs(velocity.x) < 6:
		velocity.x = 0
	
	if move_direction != 0:
		sprite.scale.x = move_direction

func camera_update(delta):
	position.x = clamp(position.x, camera.limit_left + 8, camera.limit_right - 8)
	if abs(velocity.x) > 0:
		offset += (velocity.x / abs(velocity.x))
		offset = clamp(offset, -CAMERA_OFFSET, CAMERA_OFFSET)
	camera_offset += (offset - camera_offset) / 3
	camera.position = position
	camera.position.x += camera_offset

func hitbox_update():
	var floor_normal = $SlopeDetector.get_collision_normal()
	var on_slope = int(floor_normal != Vector2(0, -1) and (is_on_floor() or was_on_floor))
	
	$Ray1.disabled = !on_slope
	$Ray2.disabled = !on_slope
	$Ray3.disabled = !on_slope
	$HitboxSlope.disabled = !on_slope
	$Hitbox.disabled = on_slope

func play_sound(sound):
	$SFX.get_node(sound).play()
