extends Node

const TILE_SIZE := 1.0
const TILE_HEIGHT := 0.5
const MAX_HEIGHT := 5
const MAX_DEPTH := -2
const SMOOTH := 5
const TECTONIC_PLATES := 15
const PLATE_MIN_SIZE := 50
const PLATE_MAX_SIZE := 100
const MAX_RIVERS := 20
const MIN_RIVERS_HEIGHT := 3
const MIN_RIVERS_DISTANCE := 5

const DIRECTIONS = {
	N = Vector2i(0, -1),
	NE = Vector2i(1, 0),
	SE = Vector2i(1, 1),
	S = Vector2i(0, 1),
	SW = Vector2i(-1, 1),
	NW = Vector2i(-1, 0)
}

var grid_size := {
	cols = 100,
	rows = 50
}

func normalize(coord):
	if coord.r < 0:
		return null
	if coord.r >= grid_size.rows:
		return null
	return { q = int(coord.q + grid_size.cols) % grid_size.cols, r = coord.r}

func hex_add(h:Hex, vec:Vector2i):
	return normalize({q = h.q + vec.x, r = h.r + vec.y})
	
func hex_distance(h:Hex, p:Vector2i) -> int:
	return min(abs(h.q - p.x), abs(h.q + grid_size.cols - p.x)) + abs(h.r - p.y)


func hexes_in_ring(center: Hex, radius:int):
	var results = []
	var hex = hex_add(center, Common.DIRECTIONS.SW * radius)
	for i in range(0, 5):
		for j in range(0, radius):
			results.append(hex)
			hex = hex_add(hex, Common.DIRECTIONS[i])
	return results

func cube_lerp(a, b, t): # for hexes
	return {
		q = lerp(a.q, b.q, t),
		r = lerp(a.r, b.r, t),
		s = lerp(a.s, b.s, t)
	}

func cube_round(frac):
	var q = round(frac.q)
	var r = round(frac.r)
	var s = round(frac.s)
	
	var q_diff = abs(q - frac.q)
	var r_diff = abs(r - frac.r)
	var s_diff = abs(s - frac.s)

	if q_diff > r_diff and q_diff > s_diff:
		q = -r-s
	elif r_diff > s_diff:
		r = -q-s
	else:
		s = -q-r
	return {q = q, r = r, s = s}

func cube_linedraw(a, b):
	var N = hex_distance(a, b)
	var results = []
	for i in range (0, N):
		results.append(cube_round(cube_lerp(a, b, 1.0/N * i)))
	return results
