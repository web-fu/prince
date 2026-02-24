class_name ElevationGenerator

static func generate(grid:HexGrid, rng: RandomNumberGenerator):
	var _noise = MapNoise.new(rng.seed, 4, 0.10)
	for hex in grid.hexes.values():
		if hex.elevation < 0: 
			continue
		var noise = _noise.get_noise(hex)
		hex.elevation += int(round((noise * Common.MAX_HEIGHT + 1)))
		hex.elevation = clamp(hex.elevation, Common.MAX_DEPTH, Common.MAX_HEIGHT)
