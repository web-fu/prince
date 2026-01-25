class_name HexGrid

var cols: int
var rows: int

var hexes := {} # Dictionary<Vector2i, Hex>

func _init(cols, rows) -> void:
	self.cols = cols
	self.rows = rows

	for col in range(0, cols):
		for row in range(0, rows):
			self._addHex(col, row)

func _addHex(col:int, row:int):
	hexes[Vector2i(col, row)] = Hex.new(col, row)

func get_hex(coord: OffsetCoord) -> Hex:
	return hexes.get(Vector2i(coord.col, coord.row), null)

func neighbors(hex:Hex) -> Array:
	var result := []
	var coords = CoordConverter.getOffsetNeighbors(hex.coord)
	for coord in coords:
		result.append(self.get_hex(coord))
	return result
