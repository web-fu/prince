extends Node3D

const LAND_TILE = preload("res://scenes/tiles/LandTile.tscn")
const SEA_TILE = preload("res://scenes/tiles/SeaTile.tscn")
const DEEP_WATER_TILE = preload("res://scenes/tiles/DeepWaterTile.tscn")
const ICE_TILE = preload("res://scenes/tiles/IceTile.tscn")
const DESERT_TILE = preload("res://scenes/tiles/DesertTile.tscn")
const FOREST_TILE = preload("res://scenes/tiles/ForestTile.tscn")

const RIVER_A = preload("res://scenes/tiles/rivers/RiverA.tscn")
const RIVER_B = preload("res://scenes/tiles/rivers/RiverB.tscn")
const RIVER_C = preload("res://scenes/tiles/rivers/RiverC.tscn")

func draw_world(grid: HexGrid):
	var sea_tile = SEA_TILE.instantiate()
	var material = sea_tile.get_child(0).get_child(0).mesh.surface_get_material(0)
	material.uv1_offset = Vector3(-0.125, 0, 0)
	
	var ice_tile = ICE_TILE.instantiate()
	material = ice_tile.get_child(0).get_child(0).mesh.surface_get_material(0)
	material.uv1_offset = Vector3(0.125, -0.5, 0)
	
	var desert_tile = DESERT_TILE.instantiate()
	material = desert_tile.get_child(0).get_child(0).mesh.surface_get_material(0)
	material.uv1_offset = Vector3(0.375, -0.25, 0)
	
	var forest_tile = FOREST_TILE.instantiate()
	material = forest_tile.get_child(0).get_child(0).mesh.surface_get_material(0)
	material.uv1_offset = Vector3(0.125, 0, 0)
	
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
		if hex.baseTemp < 0:
			return ICE_TILE.instantiate()
		if hex.elevation < -1:
			return DEEP_WATER_TILE.instantiate()
		return SEA_TILE.instantiate()
	
	if !hex.has_river:
		if hex.baseTemp < 0:
			return ICE_TILE.instantiate()
		if hex.humidity < 30:
			return DESERT_TILE.instantiate()
		if hex.humidity > 60:
			return FOREST_TILE.instantiate()
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
