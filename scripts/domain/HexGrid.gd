class_name HexGrid

var hexes := {} # Dictionary<Vector2i, Hex>

func add_hex(q:int, r:int):
	var h = Hex.new(q, r)
	hexes[Vector2i(q, r)] = h

func get_hex(q:int, r:int) -> Hex:
	return hexes.get(Vector2i(q, r), null)

func neighbors(hex:Hex) -> Array:
	var result := []
	for d in Common.DIRECTIONS.values():
		var c = Common.hex_add(hex, d)
		if c:
			var n = get_hex(c.q, c.r)
			if n:
				result.append(n)
	return result
