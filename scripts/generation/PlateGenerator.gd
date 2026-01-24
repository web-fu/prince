class_name PlateGenerator

static func generate(grid:HexGrid, rng:RandomNumberGenerator):
	var plates := []
	var unassigned := []
	
	plates.append(Plate.new(0, rng)) 
	
	for hex in grid.hexes.values():
		hex.elevation = Common.MAX_DEPTH
		unassigned.append(hex)
	
	for i in range(1, Common.TECTONIC_PLATES + 1):
		plates.append(Plate.new(i, rng))
		var col = rng.randi_range(0, Common.grid_size.cols - 1)
		var row = rng.randi_range(0, Common.grid_size.rows - 1)
		var pos = grid.get_hex(col, row)
		var plate = {
				id = i,
				frontier = [pos],
				max_size = rng.randi_range(Common.PLATE_MIN_SIZE, Common.PLATE_MAX_SIZE - 1),
				roughness = rng.randf_range(0.3, 0.9)
			}
		pos.plate_id = i
		_expand_plate(grid, plate, unassigned, rng)
	
	return plates

static func _expand_plate(
	grid: HexGrid,
	plate: Dictionary,
	unassigned: Array,
	rng: RandomNumberGenerator
) -> void:
	var frontier = plate.frontier
	var plate_id = plate.id
	var max_size = plate.max_size
	var roughness = plate.roughness

	var size := 1

	while not frontier.is_empty() and size < max_size:
		var current = frontier.pop_front()
		var neighborsCoord = CoordConverter.getOffsetNeighbors(current.coord)
		for neighborCoord in neighborsCoord:
			var neighbor = grid.get_hex(neighborCoord.col, neighborCoord.row)
			if not unassigned.has(neighbor):
				continue

			# Probabilità irregolare di crescita
			if rng.randf() > roughness:
				continue

			neighbor.plate_id = plate_id
			neighbor.elevation = 0
			unassigned.erase(neighbor)
			frontier.append(neighbor)
			
			size += 1

			if size >= max_size:
				break
