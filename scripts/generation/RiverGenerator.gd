class_name RiverGenerator extends RefCounted

static func generate_rivers(
	grid: HexGrid,
	rng: RandomNumberGenerator,
) -> Array:
	var rivers := []
	var candidates := []
	
	for candidate in grid.hexes.values():
		# avoid pole zones
		if abs(candidate.latitude) > 90 - grid.axis_tilt:
			continue
		if candidate.elevation >= Common.RIVERS_MIN_HEIGHT:
			candidates.append(candidate)
	
	while rivers.size() < Common.RIVERS_MAX:
		var source = candidates[rng.randi_range(0, candidates.size() - 1)]
		var ok = true
		for r in rivers:
			if grid.get_distance(r[0], source) < Common.RIVERS_MIN_DISTANCE:
				ok = false
				continue
		if ! ok:
			continue
		
		var river = _generate_single_river(grid, source, rng)
		
		rivers.append(river)

	return rivers

static func _generate_single_river(
	grid,
	source,
	rng: RandomNumberGenerator
) -> Array:
	var path := []
	source.river.rotationIn = rng.randi_range(0, 5) * 60
	
	var current = source
	path.append(source)

	while true:
		var candidates := []

		for n in grid.neighbors(current):
			if path.has(n):
				continue
			if n.elevation <= current.elevation:
				candidates.append(n)

		# closed basin
		if candidates.is_empty():
			break

		var next = candidates[rng.randi_range(0, candidates.size() - 1)]
		var direction = current.coord.getDirection(next.coord)
		current.has_river = true
		current.river.rotationOut = direction * 60
		next.river.rotationIn = (direction + 3) % 6  * 60
		
		if next.elevation < 0:
			break
		
		path.append(next)
		
		current = next
	
	return path
