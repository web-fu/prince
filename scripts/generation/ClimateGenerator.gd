class_name ClimateGenerator

static func generate(grid:HexGrid, rng:RandomNumberGenerator):
	var tiles = grid.hexes.values()
	
	for current in tiles:
		current.humidity = 100.0
		if current.elevation >= 0:
			current.humidity = 60
			current.baseTemp -= 6.5 * current.elevation
			
	for i in range(0, 2):
		for current in tiles:
			var direction = (6 - int(round((current.windDirection - 90) / 60))) % 6
			var axisDirection = CoordConverter.AXIAL_DIRECTIONS[direction]
			var axialTo = CoordConverter.axialSum(CoordConverter.offsetToAxial(current.coord), axisDirection)
			var to = CoordConverter.normalize(CoordConverter.axialToOffset(axialTo))
			if ! to:
				continue
			var hexTo = grid.get_hex(to)
			var hDiff = min(current.humidity, max(10, current.baseTemp))
			if hexTo.elevation > 2:
				continue
			if current.elevation >= 0:
				current.humidity -= hDiff
			hexTo.humidity += hDiff
			hexTo.humidity = min(100, hexTo.humidity)
