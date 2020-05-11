extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# Align camera limits to tile grid
	# we should probably change this later
	limit_left = round(limit_left / 16) * 16
	limit_right = round(limit_right / 16) * 16
	limit_top = round(limit_top / 16) * 16
	limit_bottom = round(limit_bottom / 16) * 16
