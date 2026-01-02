class_name Tectonics

static func compute_stress(grid:HexGrid, plates:Array):
	for hex in grid.hexes.values():
		for n in grid.neighbors(hex):
			if n.plate_id != hex.plate_id:
				var p1 = plates[hex.plate_id]
				var p2 = plates[n.plate_id]
				var delta = p1.movement - p2.movement
				hex.stress += delta.length()
