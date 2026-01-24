extends Node3D

const LAND_TILE = preload("res://scenes/tiles/LandTile.tscn")
const SEA_TILE = preload("res://scenes/tiles/SeaTile.tscn")

func draw_world(grid):
	for col in range(-Common.grid_size.cols, Common.grid_size.cols * 2):
		for row in range(0, Common.grid_size.rows):
			var normCoord = CoordConverter.normalize(OffsetCoord.new(col, row))
			var hex = grid.get_hex(normCoord.col, normCoord.row)
			var tile = _get_tile(grid, hex)
			var coord = CoordConverter.offsetToWorld(col, row)
			coord.y = hex.elevation * Common.TILE_HEIGHT if hex.elevation > 0 else 0
			tile.position = coord
			add_child(tile)

func _get_tile(grid: HexGrid, hex:Hex):
	if hex.elevation < 0:
		return SEA_TILE.instantiate()
	
	if hex.elevation >= 0: 
		return LAND_TILE.instantiate()
