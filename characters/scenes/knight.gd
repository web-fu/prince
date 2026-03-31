extends Node3D

var is_selected := false
var world_position:
	set(hex):
		set_world_position(hex)

@onready var area_3d: Area3D = $Area3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _process(delta): 
	update_animation()

func get_state() -> String:
	if is_selected:
		return 'Idle_B'
	return 'Idle_A'

func set_world_position(hex):
	position = hex.getWorldPosition()

func update_animation() -> void:
	animation_player.play("Knight/"+get_state())

func _on_area_3d_selection_toggled(selection: Variant) -> void:
	set_process_unhandled_input(selection)
	is_selected = selection
