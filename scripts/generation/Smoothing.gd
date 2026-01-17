class_name Smoothing

static func smooth(grid:HexGrid):
	for i in range(1, 5):
		for hex in grid.hexes.values():
			for n in grid.neighbors(hex):
				var diff = hex.elevation - n.elevation
				if abs(diff) > 1:
					hex.elevation = n.elevation + sign(diff)
