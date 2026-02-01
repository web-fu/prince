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
		
		rivers.append(river)

	return rivers

static func _generate_single_river(
	grid,
	source,
	rng: RandomNumberGenerator
) -> Array:
	var path := []
	var current = source
	path.append(source)

	while true:
		# Se bacino chiuso
		var candidates := []

		for n in grid.neighbors(current):
			if path.has(n):
				continue
			if n.elevation <= current.elevation:
				candidates.append(n)

		if candidates.is_empty():
			break   # lago / bacino chiuso

		var next = candidates[rng.randi_range(0, candidates.size() - 1)]
		var direction = current.coord.getDirection(next.coord)
		current.has_river = true
		current.river.rotationOut = direction * 60
		next.river.rotationIn = (direction + 3) % 6  * 60
		print(current.data(), " ", direction, " ", current.river.rotationIn, " ", current.river.rotationOut)
		
		if next.elevation < 0 :
			break
		
		path.append(next)
		
		current = next
	
	return path
