extends Panel

@onready var title = $VBoxContainer/Title
@onready var elevation = $VBoxContainer/Elevation
@onready var river = $VBoxContainer/River

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_tile(hex: Hex):
	visible = true
	title.text = "Tile " + str(hex.coord.col) + ", " + str(hex.coord.row)
	elevation.text = "Elevation: " + str(hex.elevation)
	if hex.has_river:
		river.text = "River In:" + str(hex.river.rotationIn) + " Out " + str(hex.river.rotationOut)
	else:
		river.text = ""
