class_name HexGrid

var cols: int
var rows: int
var axis_tilt := 23.0 # DO NOT PUT 0!
var temp_min := -10.0
var temp_max := 40.0
var tectonic_plates : int
var land_percentage : float

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
	var axial = CoordConverter.offsetToAxial(hex.coord)
	var neighbors = CoordConverter.getAxialNeighbors(axial)
	for neighbor in neighbors:
		var neighborCoord = CoordConverter.axialToOffset(neighbor)
		neighborCoord = normalize(neighborCoord)
		if neighborCoord:
			result.append(self.get_hex(neighborCoord))
	return result

func rand_hex(rng: RandomNumberGenerator):
	var col = rng.randi_range(0, self.cols - 1)
	var row = rng.randi_range(0, self.rows - 1)
	return self.get_hex(OffsetCoord.new(col, row))

func get_distance(a, b):
	var axialA1 = CoordConverter.offsetToAxial(a.coord)
	var axialA2 = CoordConverter.offsetToAxial(OffsetCoord.new(a.coord.col + cols, a.coord.row))
	var axialA3 = CoordConverter.offsetToAxial(OffsetCoord.new(a.coord.col - cols, a.coord.row))
	var axialB = CoordConverter.offsetToAxial(b.coord)
	
	return min(CoordConverter.axialDistance(axialA1, axialB), CoordConverter.axialDistance(axialA2, axialB), CoordConverter.axialDistance(axialA3, axialB))

func normalize(coord: OffsetCoord):
	if coord.row < 0:
		return null
	if coord.row >= rows:
		return null
	return OffsetCoord.new((coord.col + cols) % cols, coord.row)
