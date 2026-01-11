class_name WorldGenerator

var rng := RandomNumberGenerator.new()
var grid := HexGrid.new()

func generate(seed:int):
	rng.seed = seed

	# crea griglia
	for q in range(0, Common.grid_size.q):
		for r in range(0, Common.grid_size.q):
			grid.add_hex(q, r)

	var plates = PlateGenerator.generate(grid, Common.TECTONIC_PLATES, rng)
	
	Tectonics.compute_stress(grid, plates)
	ElevationGenerator.apply(grid)
	Smoothing.smooth(grid, 5)

	return grid
