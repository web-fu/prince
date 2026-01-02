class_name ElevationGenerator

static func apply(grid:HexGrid):
	for hex in grid.hexes.values():
		hex.elevation += int(round(hex.stress))
		hex.elevation = clamp(hex.elevation, -5, 5)
