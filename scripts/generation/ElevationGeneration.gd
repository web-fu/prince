class_name ElevationGenerator

static func apply(grid:HexGrid):
	for hex in grid.hexes.values():
		hex.elevation += int(round(hex.stress))
		hex.elevation = clamp(hex.elevation, Common.MAX_DEPTH, Common.MAX_HEIGHT)
