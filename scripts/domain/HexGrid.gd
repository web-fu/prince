class_name HexGrid

var cols: int
var rows: int
var axis_tilt := 23.0 # DO NOT PUT 0!
var temp_min := -20.0
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
	if abs(hex.latitude) < axis_tilt:
		hex.windDirection = - lerp_angle(deg_to_rad(180), deg_to_rad(90), abs(hex.latitude) / axis_tilt)
		if sign(hex.latitude):
			hex.windDirection *= sign(hex.latitude)
	if abs(hex.latitude) >= axis_tilt and abs(hex.latitude) < 90 - axis_tilt:
		hex.windDirection = lerp_angle(deg_to_rad(90), deg_to_rad(0), (abs(hex.latitude) - axis_tilt) / (90 - axis_tilt * 2) ) * sign(hex.latitude)
	if abs(hex.latitude) >= 90 - axis_tilt:
		hex.windDirection = lerp_angle(deg_to_rad(0), deg_to_rad(270), (abs(hex.latitude) + axis_tilt - 90) / axis_tilt) * sign(hex.latitude)
	hex.windDirection = int(round(rad_to_deg(hex.windDirection) + 360)) % 360
	
	hexes[Vector2i(col, row)] = hex

func get_hex(coord: OffsetCoord) -> Hex:
	return hexes.get(Vector2i(coord.col, coord.row), null)

func neighbors(hex:Hex) -> Array:
	var result := []
	var coords = CoordConverter.getOffsetNeighbors(hex.coord)
	for coord in coords:
		result.append(self.get_hex(coord))
	return result
