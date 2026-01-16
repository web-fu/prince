extends Node3D

const LAND_TILE = preload("res://scenes/LandTile.tscn")
const SEA_TILE = preload("res://scenes/SeaTile.tscn")

@export var seed := hash("Godot")

func _ready():
	var generator = WorldGenerator.new()
	var grid = generator.generate(seed)
	$WorldView.draw_world(grid)
