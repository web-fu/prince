class_name WorldGenerator

var rng := RandomNumberGenerator.new()
var grid := HexGrid.new()

func generate(seed:int):
	rng.seed = seed

	# crea griglia
	for col in range(0, Common.grid_size.cols):
		for row in range(0, Common.grid_size.rows):
			grid.add_hex(col, row)

	var plates = PlateGenerator.generate(grid, rng)
	Tectonics.compute_stress(grid, plates)
	ElevationGenerator.apply(grid)
	Smoothing.smooth(grid)

	return grid
