extends Camera3D

@export var camera_speed = 0.25 

var direction = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var vertical_camera_top = position.y * cos(deg_to_rad(rotation.x))
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if position.z > vertical_camera_top:
		if Input.is_action_pressed("move_top"):
			direction.z -= 1
	if position.z < Common.grid_size.q * 1.3:
		if Input.is_action_pressed("move_bottom"):
			direction.z += 1
	position = lerp(position, direction, camera_speed)
	#if position.x < - Common.grid_size.q / 4:
		#position.x += Common.grid_size.q
		#direction.x += Common.grid_size.q
	#if position.x > Common.grid_size.q * 5 / 4:
		#position.x -= Common.grid_size.q
		#direction.x -= Common.grid_size.q
