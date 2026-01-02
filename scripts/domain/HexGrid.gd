class_name HexGrid

var hexes := {} # Dictionary<Vector2i, Hex>

const DIRECTIONS = [
	Vector2i(1, 0), Vector2i(1, -1), Vector2i(0, -1),
	Vector2i(-1, 0), Vector2i(-1, 1), Vector2i(0, 1)
]

func add_hex(q:int, r:int):
	var h = Hex.new(q, r)
	hexes[Vector2i(q, r)] = h

func get_hex(q:int, r:int) -> Hex:
	return hexes.get(Vector2i(q, r), null)

func neighbors(hex:Hex) -> Array:
	var result := []
	for d in DIRECTIONS:
		var n = get_hex(hex.q + d.x, hex.r + d.y)
		if n:
			result.append(n)
	return result
