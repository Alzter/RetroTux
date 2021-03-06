extends "res://Scenes/Master/StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("walk")
	add_state("run")
	add_state("jump")
	add_state("fall")
	call_deferred("set_state", "idle")

func _state_logic(delta):
	parent.hitbox_update()
	if (state == "idle" or state == "walk" or state == "run" or state == "jump" or state == "fall"):
		jump_input()
		parent.move_input()
	parent.apply_gravity(delta)
	parent.apply_velocity()
	parent.camera_update(delta)
	parent.get_node("Label").text = str(state)

func jump_input():
	if Input.is_action_just_pressed("jump"):
		parent.jump_buffer.start()
	elif !Input.is_action_pressed("jump"):
		parent.jump_buffer.stop()
	
	if parent.jump_buffer.time_left and ((state == "idle" or state == "walk" or state == "run") or !parent.coyote_timer.is_stopped()):
		parent.jump_buffer.stop()
		parent.coyote_timer.stop()
		parent.play_sound("bigjump")
		if state == "run":
			parent.velocity.y = -parent.jump_height_max
		else:
			parent.velocity.y = -parent.jump_height
		parent.snap = false
	
	# Jump cancelling
	if state == "jump":
		if !Input.is_action_pressed("jump"):
			parent.velocity.y = 20

func _get_transition(delta):
	match state:
		"idle":
			if !parent.is_on_floor():
				return jump_state()
			elif parent.velocity.x != 0:
				return run_state()
		"walk":
			if !parent.is_on_floor():
				return jump_state()
			elif parent.velocity.x == 0:
				return "idle"
			else:
				return run_state()
		"run":
			if !parent.is_on_floor():
				return jump_state()
			elif parent.velocity.x == 0:
				return "idle"
			else:
				return run_state()
		"jump":
			if parent.is_on_floor():
				return "idle"
			else:
				return jump_state()
		"fall":
			if parent.is_on_floor():
				return "idle"
			else:
				return jump_state()

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

func jump_state():
	if parent.velocity.y >= 0:
		return "fall"
	else:
		return "jump"

func run_state():
	if abs(parent.velocity.x) > parent.RUN_SPEED - 20:
		return "run"
	else:
		return "walk"
