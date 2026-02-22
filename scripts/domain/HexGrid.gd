class_name HexGrid

var cols: int
var rows: int
var axis_tilt := 23.0 # DO NOT PUT 0!
var temp_min := -10.0
var temp_max := 40.0

var hexes := {} # Dictionary<Vector2i, Hex>

func _init(cols, rows) -> void:
	self.cols = cols
	self.rows = rows

	for col in range(0, cols):
		for row in range(0, rows):
			self._addHex(col, row)

func _addHex(col:int, row:int):
	var hex = Hex.new(col, row)
	hex.latitude = (0.5 - float(row) / float(rows)) * 180.0
	hex.longitude = float(col if col < cols / 2 else col - cols) / cols * 180.0
	hex.baseTemp = (cos(deg_to_rad(abs(hex.latitude) - axis_tilt)) + cos(deg_to_rad(abs(hex.latitude) + axis_tilt))) / 2 * (temp_max - temp_min) + temp_min
	
	hexes[Vector2i(col, row)] = hex

func get_hex(coord: OffsetCoord) -> Hex:
	return hexes.get(Vector2i(coord.col, coord.row), null)

func neighbors(hex:Hex) -> Array:
	var result := []
	var coords = CoordConverter.getOffsetNeighbors(hex.coord)
	for coord in coords:
		result.append(self.get_hex(coord))
	return result

func rand_points(n: int, rng: RandomNumberGenerator):
	var hexes = []
	for i in range(n):
		var col = rng.randi_range(0, self.cols - 1)
		var row = rng.randi_range(0, self.rows - 1)
		var hex = self.get_hex(OffsetCoord.new(col, row))
		hexes.append(hex)
	return hexes
