extends KinematicBody2D

var FLOOR = Vector2(0, -1)
var velocity = Vector2()

func _physics_process(delta):
	move_and_slide(velocity, FLOOR)
	

func get_input():
	var move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
