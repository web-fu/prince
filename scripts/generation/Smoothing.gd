class_name Smoothing

static func smooth(grid:HexGrid, iterations:int):
	for _i in iterations:
		for hex in grid.hexes.values():
			for n in grid.neighbors(hex):
				if abs(hex.elevation - n.elevation) > 1:
					hex.elevation = n.elevation + sign(hex.elevation - n.elevation)
