class_name OffsetCoord

var col:int
var row:int

func _init(col, row) -> void:
	self.col = col
	self.row = row

func north():
	var axial = CoordConverter.offsetToAxial(self)
	var axialNorth = CoordConverter.axialSum(axial, CoordConverter.AXIAL_DIRECTIONS[0])
	return CoordConverter.axialToOffset(axialNorth)
	
func northEast():
	var axial = CoordConverter.offsetToAxial(self)
	var axialNorthEast = CoordConverter.axialSum(axial, CoordConverter.AXIAL_DIRECTIONS[1])
	return CoordConverter.axialToOffset(axialNorthEast)
	
func southEast():
	var axial = CoordConverter.offsetToAxial(self)
	var axialSouthEast = CoordConverter.axialSum(axial, CoordConverter.AXIAL_DIRECTIONS[2])
	return CoordConverter.axialToOffset(axialSouthEast)
	
func south():
	var axial = CoordConverter.offsetToAxial(self)
	var axialSouth = CoordConverter.axialSum(axial, CoordConverter.AXIAL_DIRECTIONS[3])
	return CoordConverter.axialToOffset(axialSouth)
	
func southWest():
	var axial = CoordConverter.offsetToAxial(self)
	var axialSouthWest = CoordConverter.axialSum(axial, CoordConverter.AXIAL_DIRECTIONS[4])
	return CoordConverter.axialToOffset(axialSouthWest)
	
func northWest():
	var axial = CoordConverter.offsetToAxial(self)
	var axialNorthWest = CoordConverter.axialSum(axial, CoordConverter.AXIAL_DIRECTIONS[5])
	return CoordConverter.axialToOffset(axialNorthWest)

func getDirection(coord: OffsetCoord):
	var axial = CoordConverter.offsetToAxial(self)
	var axialTo = CoordConverter.offsetToAxial(coord)
	var axialDiff = {
		q = axialTo.q - axial.q, 
		r = axialTo.r - axial.r 
	}
	return CoordConverter.AXIAL_DIRECTIONS.find(axialDiff)
