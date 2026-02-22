class_name Plate

var id: int
var coord: OffsetCoord
var movement: Vector2
var hexes: Array
var max_distance: int = 0

func _init(id:int):
	self.id = id
	
func add_hex(hex: Hex):
	hexes.append(hex)
