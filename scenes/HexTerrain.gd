extends Node3D

const TILE_SIZE := 1.0
const LAND_TILE = preload("res://scenes/LandTile.tscn")
const SEA_TILE = preload("res://scenes/SeaTile.tscn")

@export var seed := 54321

func _ready():
	var generator = WorldGenerator.new()
	var grid = generator.generate(seed)
	_generate_grid(grid)

func _generate_grid(grid):
	for hex in grid.hexes.values():
		var tile = LAND_TILE.instantiate() if hex.elevation >=0 else SEA_TILE.instantiate()
		tile.position = axial_to_world(hex)
		add_child(tile)

func axial_to_world(hex) -> Vector3:
	var x = TILE_SIZE * sqrt(3) * (hex.q + hex.r * 0.5)
	var z = TILE_SIZE * 1.5 * hex.r
	var y = hex.elevation
	return Vector3(x, y, z)
