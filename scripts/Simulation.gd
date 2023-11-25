extends Node3D

signal day_passed(day)

@onready var debugInfo = %DebugInfo
var debugText = []
var init = ""

const prefabPlant = preload("res://entities/coconut_tree.tscn")
const prefabHerbivore = preload("res://entities/herbivore.tscn")
var plants
var herbivores

var time = 0
var day = 1
var tickSpeed = 100
var progressing = false

func _ready():
	spawn(prefabPlant, 32, 2.5)
	spawn(prefabHerbivore, 16, 3)
	plants = get_tree().get_nodes_in_group("Plants")
	herbivores = get_tree().get_nodes_in_group("Herbivores")
	print_debug(\
	"[DEBUG]: Total of " + str(len(plants)) + " plants spawned\n"\
	+ "[DEBUG]: Total of " + str(len(herbivores)) + " herbivores spawned")

func _physics_process(delta):
	progressTime()

func _process(delta):
	init += "Day: " + str(day)
#	init += "\nTime: " + str(time)
	init += "\nHerbivores: " + str(len(herbivores))
	
	debugInfo.text = init
	init = ""

func progressTime():
#	if time / 480 >= day:
#		day += 1
##		Signals.day_passed.emit()
#		emit_signal("day_passed")
#		countHerbivores()
#	time += 1
	if progressing: return
	progressing = true
	var timer = get_tree().create_timer(8)
	await timer.timeout
	timer = null
	day += 1
	emit_signal("day_passed")
	countHerbivores()
	progressing = false

func countHerbivores():
	herbivores = get_tree().get_nodes_in_group("Herbivores")
#	print_debug(len(herbivores))

func randomPos():
	return Vector3(randf_range(-13, 13), 0, randf_range(-13, 13))

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
