class_name WorldGenerator

var rng := RandomNumberGenerator.new()
var grid := HexGrid.new()

func generate(seed:int):
	rng.seed = seed

	# crea griglia
	for q in range(-50, 50):
		for r in range(-50, 50):
			grid.add_hex(q, r)

	var plates = PlateGenerator.generate(grid, 12, rng)
	Tectonics.compute_stress(grid, plates)
	ElevationGenerator.apply(grid)
	Smoothing.smooth(grid, 5)

	return grid
