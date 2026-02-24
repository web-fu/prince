class_name Tectonics

static func generate(grid:HexGrid):
	for hex in grid.hexes.values():
		for n in grid.neighbors(hex):
			if n.plate_id != hex.plate_id:
				var stress = float(hex.elevation >= 0) + float(n.elevation >= 0)
				if hex.elevation < 0:
					continue
				hex.elevation = Common.MAX_HEIGHT * stress / 2
	
