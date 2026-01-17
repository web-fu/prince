extends Node3D

const LAND_TILE = preload("res://scenes/LandTile.tscn")
const SEA_TILE = preload("res://scenes/SeaTile.tscn")

func draw_world(grid):
	var map_width = Common.TILE_SIZE * 1.5 * Common.grid_size.cols
	for col in range(-Common.grid_size.cols, Common.grid_size.cols * 2):
		var coord := Vector3.ZERO
		coord.x = col * Common.TILE_SIZE * 2 #* cos(deg_to_rad(30))
		#coord.z = 0 if q % 2 == 0 else Common.TILE_SIZE / 2
		for r in range(0, Common.grid_size.rows):
			var q = (col + Common.grid_size.cols) % Common.grid_size.cols
			coord.z = (r + q % 2 * 0.5) * Common.TILE_SIZE * sqrt(3) * 1.2
			var hex = grid.get_hex(q, r)
			var tile = _get_tile(hex)
			coord.y = hex.elevation * Common.TILE_HEIGHT
			tile.position = coord
			add_child(tile)

func _get_tile(hex):
	return LAND_TILE.instantiate() if hex.elevation >=0 else SEA_TILE.instantiate()
