class_name RiverGenerator extends RefCounted

static func generate_rivers(
	grid: HexGrid,
	rng: RandomNumberGenerator,
) -> Array:
	var rivers := []
	var candidates := []
	
	for candidate in grid.hexes.values():
		if candidate.elevation >= Common.MIN_RIVERS_HEIGHT:
			candidates.append(candidate)
	
	for i in range(1, Common.MAX_RIVERS):
		var source = candidates[rng.randi_range(0, candidates.size() - 1)]
		var river = _generate_single_river(grid, source, rng)
		
		for hex in river:
			hex.has_river = true
			#print(i, ": ", hex.data())
		
		rivers.append(river)

	return rivers

static func _generate_single_river(
	grid,
	source_hex,
	rng: RandomNumberGenerator
) -> Array:

	var path := []
	var current = source_hex

	while true:
		path.append(current)

		# Se arriva al mare
		if current.elevation <= 0:
			break

		# Se bacino chiuso
		var candidates := []

		for n in grid.neighbors(current):
			if path.has(n):
				continue
			if n.elevation <= current.elevation:
				candidates.append(n)

		if candidates.is_empty():
			break   # lago / bacino chiuso

		# scegli il più basso (con rumore)
		candidates.sort_custom(func(a, b):
			return (a.elevation + rng.randf_range(-0.2, 0.2)) < (b.elevation + rng.randf_range(-0.2, 0.2)))

		current = candidates[0]

	return path
