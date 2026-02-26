class_name PlateGenerator

static func generate(grid:HexGrid, rng:RandomNumberGenerator):
	var plates := []
	
	for i in range(Common.TECTONIC_PLATES):
		var col = rng.randi_range(0, grid.cols - 1)
		var row = rng.randi_range(0, grid.rows - 1)
		var hex = grid.get_hex(OffsetCoord.new(col, row))
		var plate = Plate.new(i)
		plate.coord = OffsetCoord.new(col, row)
		plates.append(plate)
	
	for hex in grid.hexes.values():
		var closest = plates[0]
		var best_dist := INF

		for plate in plates:
			var d = grid.get_distance(hex, plate)
			if d < best_dist:
				best_dist = d
				closest = plate
		
		hex.plate_id = closest.id
		plates[closest.id].add_hex(hex)

	for plate in plates:
		#avoid empty plates
		if !plate.hexes.size():
			continue
		_define_plate(grid, plate, rng)

static func _define_plate(
	grid: HexGrid,
	plate: Plate,
	rng: RandomNumberGenerator
) -> void:
	var _noise = MapNoise.new(rng.randi(), 4, 0.10)
	var vertex = plate.hexes[rng.randi_range(0, plate.hexes.size() - 1)]
	
	var max_distance = 0
	for hex in plate.hexes:
		var d1 : float = grid.get_distance(hex, plate)
		var d2 : float = grid.get_distance(hex, vertex)
		var noise = _noise.get_noise(hex)
		d2 = d1 + noise * 10
		var d = min(d1, d2)
		if d > max_distance:
			max_distance = d
		hex.vertex_distance = d
	
	plate.hexes.sort_custom(by_distance)
	
	var land_tiles = plate.hexes.size() * Common.LAND_PERCENTAGE / 100
	
	var count = 0
	for hex in plate.hexes:
		hex.elevation = 0
		count += 1
		if count >= land_tiles:
			break

static func by_distance(a, b):
	return a.vertex_distance < b.vertex_distance
