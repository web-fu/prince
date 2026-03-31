extends Area3D

signal selection_toggled(selection)

var exclusive = true
var selection_action = 'select'
var selected = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("input_event", _on_area_input_event)

func set_selected(selection):
	if selection:
		_make_exclusive()
		add_to_group("selected")
	else:
		remove_from_group("selected")
	emit_signal("selection_toggled", selection)
	selected = selection

func _make_exclusive():
	if not exclusive:
		return
	get_tree().call_group("selected", "set_selected", false)

func _on_area_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			set_selected(not selected)
