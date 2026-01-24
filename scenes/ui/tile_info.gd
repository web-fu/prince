extends Panel

@onready var title = $VBoxContainer/Title
@onready var elevation = $VBoxContainer/Elevation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_tile(hex: Hex):
	visible = true
	title.text = "Tile #" + str(hex.coord.col) + ", " + str(hex.coord.row)
	elevation.text = "Elevation: " + str(hex.elevation)
	#river = "River" + str(tile.has_river)
