extends Node3D

const TILE_SIZE := 1.0
const HEX_TILE = preload("res://scenes/HexTile.tscn")
const LAND = preload("res://materials/land.tres")
const SEA = preload("res://materials/water.tres")

@export var seed := 54321

func _ready():
	var generator = WorldGenerator.new()
	var grid = generator.generate(seed)
	_generate_grid(grid)


func _generate_grid(grid):
	var tile_index := 0
	for x in range(Common.grid_size.x):
		var tile_coordinates := Vector2.ZERO
		tile_coordinates.x = x * TILE_SIZE * cos(deg_to_rad(30))
		tile_coordinates.y = 0 if x % 2 == 0 else TILE_SIZE / 2
		for y in range(Common.grid_size.y):
			var hex = grid.get_hex(x,y)
			var tile = HEX_TILE.instantiate()
			add_child(tile)
			tile.translate(Vector3(tile_coordinates.x, hex.elevation, tile_coordinates.y))
			tile_coordinates.y += TILE_SIZE
			tile.get_node("hex_grass/hex_grass").material_override = get_tile_material(hex)


func get_tile_material(hex):
	return LAND if hex.elevation >= 0 else SEA
