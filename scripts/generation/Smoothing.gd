class_name Smoothing

static func smooth(grid:HexGrid):
	for h_max in range(Common.MAX_HEIGHT, Common.MAX_DEPTH, -1):
		for hex in grid.hexes.values():
			var max_delta = 2 if hex.elevation > 0 else 1
			for n in grid.neighbors(hex):
				var diff = hex.elevation - n.elevation
				if abs(diff) > max_delta:
					if hex.elevation >= h_max: 
						n.elevation += sign(diff) * (abs(diff) -1)
					else:
						hex.elevation -= sign(diff) * (abs(diff) -1)
