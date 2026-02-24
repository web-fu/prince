class_name MapNoise

var _noise = FastNoiseLite.new()

func _init(seed: int, octaves: int, frequency: float):
	_noise.noise_type = FastNoiseLite.NoiseType.TYPE_PERLIN
	_noise.seed = seed
	_noise.fractal_octaves = octaves
	_noise.frequency = frequency

func get_noise(hex: Hex):
	return _noise.get_noise_2d(hex.coord.col, hex.coord.row)
