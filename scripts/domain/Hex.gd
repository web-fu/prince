class_name Hex

var q:int
var r:int
var plate_id:int = 0
var elevation:int = Common.MAX_DEPTH
var stress:float = 0.0

func _init(q:int, r:int):
	self.q = q
	self.r = r
