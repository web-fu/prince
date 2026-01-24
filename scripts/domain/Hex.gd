class_name Hex

var coord: OffsetCoord
var plate_id:int = 0
var elevation:int = Common.MAX_DEPTH
var stress:float = 0.0

func _init(col:int, row:int):
	self.coord = OffsetCoord.new(col, row)

func data():
	return "col " + str(self.coord.col) + " row " + str(self.coord.row) + " e " + str(self.elevation)
