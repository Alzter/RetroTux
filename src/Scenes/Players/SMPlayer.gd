extends "res://Scenes/Master/StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	call_deferred("set_state", states.idle)

func _state_logic(delta):
	parent.horizontal_movement()
	parent.apply_gravity(delta)
	parent.apply_velocity()
	

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

func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			pass
		states.run:
			pass
		states.jump:
			pass

func _exit_state(old_state, new_state):
	pass
