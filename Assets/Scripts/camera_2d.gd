extends Camera2D


# Track the furthest position the camera has scrolled to
var max_x := -INF
var max_y := -INF  # only use this too if you want vertical ratcheting (e.g. climbing sections)

@export var lock_horizontal := true
@export var lock_vertical := false  # turn on for Metroid-style vertical shafts

func _process(_delta: float) -> void:
	var parent_pos = get_parent().global_position

	if lock_horizontal:
		max_x = max(max_x, parent_pos.x)
		global_position.x = max_x
	else:
		global_position.x = parent_pos.x

	if lock_vertical:
		max_y = max(max_y, parent_pos.y)
		global_position.y = max_y
	else:
		global_position.y = parent_pos.y
