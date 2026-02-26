extends Node3D

@export var seed := 12345
@export var tectonic_plates := 10
@export var land_percentage := 50.0
@export var axis_tilt := 23.0
@export var grid_size := {
	cols = 100,
	rows = 50
}

var rng := RandomNumberGenerator.new()
var grid : HexGrid

func _ready():
	grid = HexGrid.new(grid_size.cols, grid_size.rows)
	rng.seed = seed
	WorldGenerator.generate(grid, rng)
	$WorldView.draw_world(grid)


func _unhandled_input(event):
	var camera = $GameCamera
	if event is InputEventMouseButton and event.pressed:
		var mouse_pos = get_viewport().get_mouse_position()
		var ray_length = 1000
		var from = camera.project_ray_origin(mouse_pos)
		var to = from + camera.project_ray_normal(mouse_pos) * ray_length
		var position = from + to * (-from.y / to.y)
		var offset = CoordConverter.worldToOffset(position)
		
		$TileSelected.move(offset)
