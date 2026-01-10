class_name Plate

var id:int
var origin:Vector2i
var movement:Vector2
var is_continental:bool
var base_elevation:int

func _init(id:int, origin:Vector2i, rng:RandomNumberGenerator):
	self.id = id
	self.origin = origin
	movement = Vector2(
		rng.randf_range(-1, 1),
		rng.randf_range(-1, 1)
	).normalized()

	is_continental = rng.randf() < 0.3
	base_elevation = rng.randi_range(0, 5) if is_continental else rng.randi_range(-3, -1)
