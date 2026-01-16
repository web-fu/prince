extends Node3D

const LAND_TILE = preload("res://scenes/LandTile.tscn")
const SEA_TILE = preload("res://scenes/SeaTile.tscn")

func draw_world(grid):
	var map_width = Common.TILE_SIZE * sqrt(3) * Common.grid_size.q
	for wrap in range(-1, 2):
		for hex in grid.hexes.values():			
			var position = _axial_to_world(hex)
			position.x += wrap * map_width
			var tile = _get_tile(hex)
			tile.position = position
			add_child(tile)

func _get_tile(hex):
	return LAND_TILE.instantiate() if hex.elevation >=0 else SEA_TILE.instantiate()

func _axial_to_world(hex) -> Vector3:
	var x = Common.TILE_SIZE * sqrt(3) * (hex.q + hex.r * 0.5)
	var z = Common.TILE_SIZE * 1.5 * hex.r
	var y = hex.elevation #int(round(hex.elevation / Common.SMOOTH))
	return Vector3(x, y, z)
