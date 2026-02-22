class_name Hex

var coord: OffsetCoord
var plate_id:int = 0
var vertex_distance:int = 0
var elevation:int = Common.MAX_DEPTH
var has_river:bool
var river: River
var latitude: float
var longitude: float
var baseTemp: float
var humidity: float

func _init(col:int, row:int):
	self.coord = OffsetCoord.new(col, row)
	self.river = River.new(0, 180)

func getWorldPosition() -> Vector3: 
	var position = CoordConverter.offsetToWorld(coord)
	position.y = self.elevation * Common.TILE_HEIGHT if self.elevation >= 0 else - Common.TILE_HEIGHT
	return position

func data():
	return "col " + str(self.coord.col) + " row " + str(self.coord.row) + " e " + str(self.elevation)
