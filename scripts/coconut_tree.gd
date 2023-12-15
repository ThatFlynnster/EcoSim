extends Node3D

const spawnInterval = 420
var spawnTime = 0
var age = 0

const coconut = preload("res://entities/coconut.tscn")

func _ready():
	var sim = get_tree().get_first_node_in_group("Simulation")
	sim.connect("day_passed", self.day_passed)
	day_passed()

func day_passed():
#	if age >= 15: queue_free()
#	else:
#		spawn(coconut, 2, 0)
	spawn(coconut, 2, 0)
	age += 1

func _physics_process(delta):
#	if spawnTime == 0:
#		spawn(coconut, 1, 0)
#		spawnTime = spawnInterval
#		print_debug("COCONUT!")
	
	spawnTime -= 1

func randomPos():
	return Vector3(randf_range(-1, 1), 0.15, randf_range(-1, 1))

func spawn(entity, count, radius):
	var posCache = []
	var i = count
	while i > 0:
		var instance = entity.instantiate()
		var pos = randomPos()
		var posInvalid = false
		
		for _pos in posCache:
			if pos.x <= _pos.x + radius and pos.x >= _pos.x - radius\
			and pos.z <= _pos.z + radius and pos.z >= _pos.z - radius:
				posInvalid = true
		
		if posInvalid == true: continue
		
		posCache.append(pos)
		instance.position = pos
		instance.rotation.y = randf_range(-PI, PI)
		add_child(instance)
		
		i -= 1
