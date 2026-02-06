extends Node3D

const LAND_TILE = preload("res://scenes/tiles/LandTile.tscn")
const SEA_TILE = preload("res://scenes/tiles/SeaTile.tscn")
const RIVER_A = preload("res://scenes/tiles/rivers/RiverA.tscn")
const RIVER_B = preload("res://scenes/tiles/rivers/RiverB.tscn")
const RIVER_C = preload("res://scenes/tiles/rivers/RiverC.tscn")
const WET_TILE = preload("res://scenes/tiles/WetTile.tscn")
const SAND_TILE = preload("res://scenes/tiles/SandTile.tscn")

func draw_world(grid: HexGrid):
	for col in range(-grid.cols, grid.cols * 2):
		for row in range(0, grid.rows):
			var coord = OffsetCoord.new(col, row)
			var position = CoordConverter.offsetToWorld(coord)
			var normCoord = CoordConverter.normalize(coord)
			var hex = grid.get_hex(normCoord)
			var tile = _get_tile(grid, hex)
			position.y = hex.elevation * Common.TILE_HEIGHT if hex.elevation > 0 else 0
			tile.position = position
			add_child(tile)

func _get_tile(grid: HexGrid, hex:Hex):
	if hex.elevation < 0:
		return SEA_TILE.instantiate()
	
	if !hex.has_river:
		if hex.humidity < 30:
			return SAND_TILE.instantiate()
		if hex.humidity > 60:
			return WET_TILE.instantiate()
		return LAND_TILE.instantiate()
	
	var riverDiff = hex.river.rotationOut - hex.river.rotationIn
	var rotation = 0
	var tile
	
	if riverDiff == 0 or abs(riverDiff) == 180:
		tile = RIVER_A.instantiate()
		rotation = -30 - hex.river.rotationIn
		
	if abs(riverDiff) == 60 or abs(riverDiff) == 300:
		tile = RIVER_C.instantiate()
		if (abs(riverDiff) == 60):
			rotation = -hex.river.rotationIn if sign(riverDiff) > 0 else -hex.river.rotationOut
		if (abs(riverDiff) == 300):
			rotation = -hex.river.rotationOut if sign(riverDiff) > 0 else -hex.river.rotationIn
			
	if abs(riverDiff) == 120 or abs(riverDiff) == 240:
		tile = RIVER_B.instantiate()
		if (abs(riverDiff) == 120):
			rotation = -hex.river.rotationIn if sign(riverDiff) > 0 else -hex.river.rotationOut
		if (abs(riverDiff) == 240):
			rotation = -hex.river.rotationOut if sign(riverDiff) > 0 else -hex.river.rotationIn
	
	tile.rotation.y = deg_to_rad(rotation)
	return tile
