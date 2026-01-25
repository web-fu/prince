extends Camera3D

@export var camera_speed = 0.25 

var direction = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("camera_move_right"):
		direction.x += 1
	if Input.is_action_pressed("camera_move_left"):
		direction.x -= 1
	if Input.is_action_pressed("camera_move_down") and position.z < Common.grid_size.rows * 2:
		direction.z += 1
	if Input.is_action_pressed("camera_move_up") and position.z > 0:
		direction.z -= 1
	if Input.is_action_pressed("camera_zoom_in") and position.y > 5:
		direction.y -=1
	if Input.is_action_pressed("camera_zoom_out") and position.y < 50:
		direction.y +=1
		
	if position.x < - Common.grid_size.cols * Common.TILE_SIZE * sqrt(3) / 4:
		position.x += Common.grid_size.cols * Common.TILE_SIZE * sqrt(3)
		direction.x += Common.grid_size.cols * Common.TILE_SIZE * sqrt(3)
	if position.x > Common.grid_size.cols * Common.TILE_SIZE * sqrt(3) * 5 / 4:
		position.x -= Common.grid_size.cols * Common.TILE_SIZE * sqrt(3)
		direction.x -= Common.grid_size.cols * Common.TILE_SIZE * sqrt(3)
	position = lerp(position, direction, camera_speed)
