class_name Plate

var id: int
var coord: OffsetCoord
var hexes: Array

func _init(id:int):
	self.id = id
	
func add_hex(hex: Hex):
	hexes.append(hex)
