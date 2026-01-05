extends Node

const TILE_SIZE := 1.0
const TILE_HEIGHT := 0.125

var grid_size := {
	x = 200,
	y = 100
}
var map : Array[Array]
var map_seed

func _init():
	map_seed = hash("Godot")

func oddq_to_cube(hex):
	var parity = hex.x&1
	var q = hex.x
	var r = hex.y - (hex.x - parity) / 2
	return {q = q, r = r, s = -q-r}

func cube_to_oddq(cube):
	var parity = int(cube.q)&1
	var col = cube.q
	var row = cube.r + (cube.q - parity) / 2
	return normalize({x = col, y = row})

func cube_add(cube, vec):
	return {q = cube.q + vec.q, r = cube.r + vec.r, s =  cube.s + vec.s}

func cube_subtract(a, b):
	return {q = a.q-b.q, r = a.r-b.r, s = a.s - b.s}

func cube_distance(a, b):
	var vec = cube_subtract(a, b)
	return (abs(vec.q) + abs(vec.r) + abs(vec.s)) / 2

func cubes_in_radius(center, radius):
	var results = []
	for  q in range(-radius, radius):
		for r in range(max(-radius, -q-radius), min(+radius, -q+radius)):
			var s = -q-r
			results.append(cube_add(center, {q = q, r = r, s = s}))
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
	var N = cube_distance(a, b)
	var results = []
	for i in range (0, N):
		results.append(cube_round(cube_lerp(a, b, 1.0/N * i)))
	return results

func normalize(tile):
	if tile.y < 0:
		return null
	if tile.y >= grid_size.y:
		return null
	return { x = int(tile.x + grid_size.x) % grid_size.x, y = tile.y}
