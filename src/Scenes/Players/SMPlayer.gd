extends "res://Scenes/Master/StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	call_deferred("set_state", states.idle)

func _state_logic(delta):
	parent.move_input()
	parent.apply_gravity(delta)
	parent.apply_velocity()
	get_tree().current_scene.get_node("Camera2D").position = parent.position

func _input(event):
	if Input.is_action_pressed("jump") and ([states.idle, states.run].has(state) or !parent.coyote_timer.has_stopped()):
		parent.coyote_timer.stop()
		parent.velocity.y = -parent.JUMP_HEIGHT
		parent.jumping = true
	
	# Jump cancelling
	if state == states.jump:
		if !Input.is_action_pressed("jump"):
			parent.velocity.y = 0

func _get_transition(delta):
	match state:
		states.idle:
			if !parent.is_on_floor():
				return states.jump
			elif parent.velocity.x != 0:
				return states.run
		states.run:
			if !parent.is_on_floor():
				return states.jump
			elif parent.velocity.x == 0:
				return states.idle
		states.jump:
			if parent.is_on_floor():
				return states.idle
			if parent.velocity.y >= 0:
				return states.fall
		states.fall:
			if parent.is_on_floor():
				return states.idle
			if parent.velocity.y < 0:
				return states.jump

func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			pass
		states.run:
			pass
		states.jump:
			pass
		states.fall:
			if !parent.is_on_floor() and parent.was_on_floor:
				parent.coyote_timer.start()

func _exit_state(old_state, new_state):
	pass
