class_name CoordConverter

const AXIAL_DIRECTIONS = [
	{ q = 1, r = 0 },   # East
	{ q = 1, r = -1 },  # North East
	{ q = 0, r = -1 },  # North West
	{ q = -1, r = 0 },  # West
	{ q = -1, r = 1 },  # South West
	{ q = 0, r = 1 },   # South East
]

static func offsetToAxial(coord: OffsetCoord):
	var q = coord.col
	var r = coord.row - (coord.col - (coord.col & 1)) / 2
	return AxialCoord.new(q, r)

static func axialToOffset(axial: AxialCoord):
	var col = axial.q
	var row = axial.r + (axial.q - (axial.q & 1)) / 2
	return OffsetCoord.new(col, row)

static func roundAxial(q: int, r: int):
	# Convert to cubic coordinates for rounding
	var s = -q - r
	var rq = round(q)
	var rr = round(r)
	var rs = round(s)

	var qDiff = abs(rq - q)
	var rDiff = abs(rr - r)
	var sDiff = abs(rs - s)

	# If rounding error is too large, adjust
	if (qDiff > rDiff && qDiff > sDiff):
		rq = -rr - rs
	elif (rDiff > sDiff):
		rr = -rq - rs
	else:
		rs = -rq - rr

	return { q = rq, r = rr }
	
static func axialSum(axial, vector):
	return AxialCoord.new(axial.q + vector.q, axial.r + vector.r)

static func axialDistance(a, b):
	# Using cubic coordinates formula (more efficient)
	var aS = -(a.q + a.r)
	var bS = -(b.q + b.r)

	return (abs(a.q - b.q) + abs(a.r - b.r) + abs(aS - bS)) / 2

static func offsetDistance(a: OffsetCoord, b: OffsetCoord):
	var axialA1 = offsetToAxial(a)
	var axialA2 = offsetToAxial(OffsetCoord.new(a.col + Common.grid_size.cols, a.row))
	var axialB = offsetToAxial(b)
	
	return min(axialDistance(axialA1, axialB), axialDistance(axialA2, axialB))

static func getAxialNeighbors(axial: AxialCoord):
	var result = []
	for dir in AXIAL_DIRECTIONS:
		result.append(AxialCoord.new(axial.q + dir.q, axial.r + dir.r)) 
	return result

static func getOffsetNeighbors(coord: OffsetCoord):
	var axial = offsetToAxial(coord)
	var neighbors = getAxialNeighbors(axial)
	var result = []
	for neighbor in neighbors:
		var neighborCoord = axialToOffset(neighbor)
		neighborCoord = normalize(neighborCoord)
		if neighborCoord:
			result.append(neighborCoord)
	return result
	
static func getCoordsInRadius(coord: OffsetCoord, radius: int):
	var results = []
	var axial = offsetToAxial(coord)
	for q in range(-radius, radius):
		for r in range(max(-radius, -q-radius), min(+radius, -q+radius)):
			var axialResult = axialSum(axial, {q = q, r = r})
			var offsetResult = normalize(axialToOffset(axialResult))
			if offsetResult:
				results.append(offsetResult)
	return results

static func offsetToWorld(coord: OffsetCoord):
	var scale = Common.TILE_SIZE
	var r_inner = 1.0 # inner radius in model
	var R = 2 / sqrt(3) # outer radius in model (~1.1547)

	# Flat Topped Offset-X layout (matching current implementation)
	var spacingX = 1.5 * R * scale
	var spacingZ = 2.0 * r_inner * scale
	var offsetZ = r_inner * scale
	
	var worldX = coord.col * spacingX
	var worldZ = coord.row * spacingZ + (coord.col&1) * offsetZ

	return Vector3(worldX, 0, worldZ)


static func worldToOffset(world: Vector3):
	var scale = Common.TILE_SIZE
	var r_inner = 1.0
	var R = 2 / sqrt(3)
	var spacingX = 1.5 * R * scale
	var spacingZ = 2.0 * r_inner * scale
	var offsetZ = r_inner * scale

	var col = int(round(world.x / spacingX))
	var row = int(round((world.z - (col % 2) * offsetZ) / spacingZ))
	
	return normalize(OffsetCoord.new(col, row))

static func normalize(coord: OffsetCoord):
	if coord.row < 0:
		return null
	if coord.row >= Common.grid_size.rows:
		return null
	return OffsetCoord.new((coord.col + Common.grid_size.cols) % Common.grid_size.cols, coord.row)
