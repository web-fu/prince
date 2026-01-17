extends Camera3D

@export var camera_speed = 0.25 

var direction = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var vertical_camera_top = position.z * cos(deg_to_rad(rotation.x))
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down") and position.y > 5:
		direction.y -=1
	if Input.is_action_pressed("move_up") and position.y < 100 :
		direction.y +=1
	if Input.is_action_pressed("move_top") and position.z > 0:
		direction.z -= 1
	if Input.is_action_pressed("move_bottom") and position.z < Common.grid_size.r * 3:
		direction.z += 1
	if position.x < - Common.grid_size.q * Common.TILE_SIZE * sqrt(3) / 4:
		position.x += Common.grid_size.q * Common.TILE_SIZE * sqrt(3)
		direction.x += Common.grid_size.q * Common.TILE_SIZE * sqrt(3)
	if position.x > Common.grid_size.q * Common.TILE_SIZE * sqrt(3) * 5 / 4:
		position.x -= Common.grid_size.q * Common.TILE_SIZE * sqrt(3)
		direction.x -= Common.grid_size.q * Common.TILE_SIZE * sqrt(3)
	position = lerp(position, direction, camera_speed)
