class_name ClimateGenerator

static func generate(grid:HexGrid, rng:RandomNumberGenerator):
	var tiles = grid.hexes.values()
	var h_noise = MapNoise.new(rng.seed, 4, 0.05)
	var t_noise = MapNoise.new(rng.seed, 5, 0.04)
	
	for current in tiles:
		current.humidity = 100.0
		if current.elevation >= 0:
			current.humidity = (h_noise.get_noise(current) + 0.5) * 100
			current.baseTemp -= 6.5 * current.elevation + t_noise.get_noise(current) * 5
