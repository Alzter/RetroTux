extends "res://Scenes/Master/StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	call_deferred("set_state", "idle")

func _state_logic(delta):
	_jump_inputs()
	parent.move_input()
	parent.apply_gravity(delta)
	parent.apply_velocity()
	parent.camera_update()
	parent.get_node("Label").text = str(state)

func _jump_inputs():
	if Input.is_action_just_pressed("jump"):
		parent.jump_buffer.start()
	elif !Input.is_action_pressed("jump"):
		parent.jump_buffer.stop()
	
	if parent.jump_buffer.time_left and ((state == "idle" or state == "run") or !parent.coyote_timer.is_stopped()):
		parent.jump_buffer.stop()
		parent.coyote_timer.stop()
		parent.velocity.y = -parent.JUMP_HEIGHT
		parent.snap = false
	
	# Jump cancelling
	if state == "jump":
		if !Input.is_action_pressed("jump"):
			parent.velocity.y = 0

func _get_transition(delta):
	match state:
		"idle":
			if !parent.is_on_floor():
				return _jump_state()
			elif parent.velocity.x != 0:
				return "run"
		"run":
			if !parent.is_on_floor():
				return _jump_state()
			elif parent.velocity.x == 0:
				return "idle"
		"jump":
			if parent.is_on_floor():
				return "idle"
			else:
				return _jump_state()
		"fall":
			if parent.is_on_floor():
				return "idle"
			else:
				return _jump_state()

func _enter_state(new_state, old_state):
	match new_state:
		"idle":
			pass
		"run":
			pass
		"jump":
			pass
		"fall":
			if parent.was_on_floor:
				parent.coyote_timer.start()
				parent.velocity.y = 0

func _exit_state(old_state, new_state):
	pass

func _jump_state():
	if parent.velocity.y >= 0:
		return "fall"
	else:
		return "jump"
