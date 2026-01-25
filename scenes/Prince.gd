extends Node3D

@export var seed := 12345

var grid: HexGrid

func _ready():
	var generator = WorldGenerator.new()
	grid = generator.generate(seed)
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
		if offset:
			var hex = grid.get_hex(offset.col, offset.row)
			$TileInfo.show_tile(hex)
			$WorldView/TileSelected.move(hex.coord)
