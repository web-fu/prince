extends Node3D

var coord := OffsetCoord.new(0, 0)
var is_selected := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var coordNew: OffsetCoord
	if ! is_selected:
		return
	if Input.is_action_just_released("axial_move_north"):
		coordNew = self.coord.north()
	if Input.is_action_just_released("axial_move_north_east"):
		coordNew = self.coord.northEast()
	if Input.is_action_just_released("axial_move_south_east"):
		coordNew = self.coord.southEast()
	if Input.is_action_just_released("axial_move_south"):
		coordNew = self.coord.south()
	if Input.is_action_just_released("axial_move_south_west"):
		coordNew = self.coord.southWest()
	if Input.is_action_just_released("axial_move_north_west"):
		coordNew = self.coord.northWest()
	
	if coordNew:
		self.move(get_parent().grid.get_hex(coordNew))

func move(hex: Hex):
	self.coord = hex.coord
	self.position = hex.getWorldPosition()
