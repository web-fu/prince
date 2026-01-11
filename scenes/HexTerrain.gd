extends Node3D

const LAND_TILE = preload("res://scenes/LandTile.tscn")
const SEA_TILE = preload("res://scenes/SeaTile.tscn")

@export var seed := 54321

func _ready():
	var generator = WorldGenerator.new()
	var grid = generator.generate(seed)
	_generate_grid(grid)

func _generate_grid(grid):
	for hex in grid.hexes.values():
		var tile = get_tile(hex)
		tile.position = axial_to_world(hex)
		add_child(tile)

func get_tile(hex):
	return LAND_TILE.instantiate() if hex.elevation >=0 else SEA_TILE.instantiate()

func axial_to_world(hex) -> Vector3:
	var x = Common.TILE_SIZE * sqrt(3) * (hex.q + hex.r * 0.5)
	var z = Common.TILE_SIZE * 1.5 * hex.r
	var y = hex.elevation #int(round(hex.elevation / Common.SMOOTH))
	return Vector3(x, y, z)
