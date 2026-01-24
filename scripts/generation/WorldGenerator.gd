class_name WorldGenerator

var rng := RandomNumberGenerator.new()
var grid := HexGrid.new(Common.grid_size.cols, Common.grid_size.rows)

func generate(seed:int):
	rng.seed = seed
	var plates = PlateGenerator.generate(grid, rng)
	Tectonics.compute_stress(grid, plates)
	ElevationGenerator.apply(grid)
	Smoothing.smooth(grid)

	return grid
