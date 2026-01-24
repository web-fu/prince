class_name CoordConverter

const AXIAL_DIRECTIONS = [
	{ q = 1, r = 0 },   # East
	{ q = 1, r = -1 },  # North East
	{ q = 0, r = -1 },  # North West
	{ q = -1, r = 0 },  # West
	{ q = -1, r = 1 },  # South West
	{ q = 0, r = 1 },   # South East
]

static func offsetToAxial(col: int, row: int):
	var q = col
	var r = row - (col - (col & 1)) / 2
	return {q = q, r = r}

static func axialToOffset(q: int, r: int):
	var col = q
	var row = r + (q - (q & 1)) / 2
	return OffsetCoord.new(col, row)

static func axialToPixel(q: int, r: int):
	var x = Common.TILE_SIZE * (sqrt(3) * q + (sqrt(3) / 2) * r)
	var y = Common.TILE_SIZE * ((3 / 2) * r)
	return Vector2(x, y)

static func pixelToAxial(pixel: Vector2):
	# Inverse of axialToPixel
	# From: x = Common.TILE_SIZE * (√3 * q + √3/2 * r)
	#       y = Common.TILE_SIZE * (3/2 * r)
	#
	# Solve for q and r:
	# r = (2/3) * (y / Common.TILE_SIZE)
	# q = (x / Common.TILE_SIZE - √3/2 * r) / √3
	#   = (x / Common.TILE_SIZE) / √3 - r/2

	var r = (2 / 3) * (pixel.y / Common.TILE_SIZE)
	var q = pixel.x / (Common.TILE_SIZE * sqrt(3)) - r / 2

	# Round to nearest hex
	return roundAxial(q, r)

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

static func axialDistance(a, b):
	# Using cubic coordinates formula (more efficient)
	var aS = -(a.q + a.r)
	var bS = -(b.q + b.r)

	return (abs(a.q - b.q) + abs(a.r - b.r) + abs(aS - bS)) / 2

static func getAxialNeighbors(q: int, r: int):
	var result = []
	for dir in AXIAL_DIRECTIONS:
		result.append({
			q = q + dir.q,
			r = r + dir.r
		}) 
	return result

static func getOffsetNeighbors(coord: OffsetCoord):
	var axial = offsetToAxial(coord.col, coord.row)
	var neighbors = getAxialNeighbors(axial.q, axial.r)
	var result = []
	for neighbor in neighbors:
		var neighborCoord = axialToOffset(neighbor.q, neighbor.r)
		neighborCoord = normalize(neighborCoord)
		if neighborCoord:
			result.append(neighborCoord)
	return result

static func offsetToWorld(col: int, row: int):
	var scale = Common.TILE_SIZE
	var r_inner = 1.0 # inner radius in model
	var R = 2 / sqrt(3) # outer radius in model (~1.1547)

	# Flat Topped Offset-X layout (matching current implementation)
	var spacingX = 1.5 * R * scale
	var spacingZ = 2.0 * r_inner * scale
	var offsetZ = r_inner * scale
	
	var worldX = col * spacingX
	var worldZ = row * spacingZ + (col&1) * offsetZ

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


static func axialToWorld(
	q: int,
	r: int,
	#mapWidth: number,
	#mapHeight: number,
):
	# Convert to offset coordinates first to match current rendering
	var offset = axialToOffset(q, r)
	var scale = Common.TILE_SIZE
	var r_inner = 1.0 # inner radius in model
	var R = 2 / sqrt(3) # outer radius in model (~1.1547)

	# Flat Topped Offset-X layout (matching current implementation)
	var spacingX = 1.5 * R * scale
	var spacingZ = 2.0 * r_inner * scale
	var offsetZ = r_inner * scale

	return Vector3(spacingX, 0, spacingZ)
	# Mapping: User X -> Three.js X, User Y -> Three.js Z
	#var worldX = (offset.x - mapWidth / 2) * spacingX
	#var worldZ = (offset.y - mapHeight / 2) * spacingZ + (offset.x % 2) * offsetZ
#
	#return Vector3(worldX, 0, worldZ)

static func worldToAxial(world: Vector3):
	var scale = Common.TILE_SIZE
	var r_inner = 1.0
	var R = 2 / sqrt(3)
	var spacingX = 1.5 * R * scale
	var spacingZ = 2.0 * r_inner * scale
	var offsetZ = r_inner * scale

	# Reverse of axialToWorld
	var offsetX = int(round(world.x / spacingX))
	var offsetY = int(round((world.z - (offsetX % 2) * offsetZ) / spacingZ))
	
	return offsetToAxial(round(offsetX), round(offsetY))
