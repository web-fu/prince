class_name HexGrid

var hexes := {} # Dictionary<Vector2i, Hex>

func add_hex(col:int, row:int):
	var h = Hex.new(col, row)
	hexes[Vector2i(col, row)] = h

func get_hex(col:int, row:int) -> Hex:
	return hexes.get(Vector2i(col, row), null)

func neighbors(hex:Hex) -> Array:
	var result := []
	var coords = CoordConverter.getOffsetNeighbors(hex.coord)
	for coord in coords:
		result.append(self.get_hex(coord.col, coord.row))
	return result
