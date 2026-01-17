class_name Plate

var id:int
var movement:Vector2

func _init(id:int, rng:RandomNumberGenerator):
	self.id = id	
	rand_movement(rng)

func rand_movement(rng: RandomNumberGenerator):
	movement = Common.DIRECTIONS[rng.randi_range(0, 5)]
