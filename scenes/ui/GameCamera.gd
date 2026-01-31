extends Camera3D

@onready var tileSelected = $"../TileSelected"

@export var camera_speed = 0.25 

const AXIS_Z_LOCK = 25

var deadzone_ratio = 0.9

var direction = position

var check

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("camera_move_right"):
		direction.x += 1
	if Input.is_action_pressed("camera_move_left"):
		direction.x -= 1
		
	if Input.is_action_pressed("camera_move_down") and position.z < Common.grid_size.rows * 2:
		direction.z += 1
	if Input.is_action_pressed("camera_move_up") and position.z > AXIS_Z_LOCK:
		direction.z -= 1
	
	if Input.is_action_pressed("camera_zoom_out") and position.y < 50:
		direction.y +=1
	if Input.is_action_pressed("camera_zoom_in") and position.y > 10:
		direction.y -=1
	
	if position.x < - Common.grid_size.cols * Common.TILE_SIZE * sqrt(3) / 4:
		position.x += Common.grid_size.cols * Common.TILE_SIZE * sqrt(3)
		direction.x += Common.grid_size.cols * Common.TILE_SIZE * sqrt(3)
	if position.x > Common.grid_size.cols * Common.TILE_SIZE * sqrt(3) * 5 / 4:
		position.x -= Common.grid_size.cols * Common.TILE_SIZE * sqrt(3)
		direction.x -= Common.grid_size.cols * Common.TILE_SIZE * sqrt(3)
	position = lerp(position, direction, camera_speed)
	
	var p = get_camera_ground_point()
	DebugDraw3D.draw_sphere(p, 0.3, Color.RED)

func get_camera_ground_point() -> Vector3:
	var origin = global_position
	var direction = -global_transform.basis.z.normalized()

	# Evita divisioni per zero
	if abs(direction.y) < 0.0001:
		return Vector3.ZERO

	# t = distanza lungo il raggio
	var t = -origin.y / direction.y

	return origin + direction * t

func move_camera_to_ground_point_smooth(ground_point: Vector3):
	var direction = -global_transform.basis.z.normalized()
	
	print(direction)
	
	if abs(direction.y) < 0.0001:
		return

	var t = -global_position.y / direction.y
	var desired_pos = ground_point - direction * t
	
	print(desired_pos)
	#global_position = desired_pos


func adjust(elementPosition: Vector3):
	var cameraPosition = get_camera_ground_point()
	var diffPosition = cameraPosition - elementPosition
	
	print('...')
	print(cameraPosition)
	print(elementPosition)
	print(diffPosition)
	
	#if abs(diffPosition.x) > 10 || abs(diffPosition.z) > 10:
	move_camera_to_ground_point_smooth(elementPosition)
