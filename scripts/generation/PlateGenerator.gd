class_name PlateGenerator

static func generate(grid:HexGrid, plate_count:int, rng:RandomNumberGenerator) -> Array:
	var plates := []

	# 1. scegli nuclei
	var keys = grid.hexes.keys()
	keys.shuffle()
	for i in plate_count:
		var pos = keys[i]
		var plate = Plate.new(i, pos, rng)
		plates.append(plate)

	# 2. assegna la placca più vicina
	for hex in grid.hexes.values():
		var closest = plates[0]
		var best_dist := INF

		for plate in plates:
			var d = Common.hex_distance(hex, plate.origin)
			if d < best_dist:
				best_dist = d
				closest = plate

		hex.plate_id = closest.id
		hex.elevation = closest.base_elevation #* Common.SMOOTH

	return plates
