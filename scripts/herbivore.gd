extends CharacterBody3D

@onready var nav: NavigationAgent3D = $NavigationAgent3D

var speed = 2.0
var size = 1.0
var view = 1.0

const speedRange = Vector2(1.0, 4.0)
const sizeRange = Vector2(0.5, 2.0)
const viewRange = Vector2(0.5, 2.0)

const prefabChild = preload("res://entities/herbivore.tscn")
const prefabTree = preload("res://entities/coconut_tree.tscn")
var sim
var viewRangeComponent
var predatorList
var foodList

var direction
var wanderTime
var energy = 0
var alive = true

var plants

func _ready():
	sim = get_tree().get_first_node_in_group("Simulation")
	sim.connect("day_passed", self.day_passed)
	viewRangeComponent = $ViewRangeComponent
	viewRangeComponent.connect("detected", self.detected)
	wander()

func _physics_process(delta):
	if !alive: return
	bounce()
	direction = -global_transform.basis.z
	velocity = direction * speed
	move_and_slide()
	plants = 0
	hunt()
	flee()

func _process(delta):
	if !alive: return
	if wanderTime > 0: wanderTime -= delta
	else: wander()

func day_passed():
	predatorList = null
	if energy == 0:
#		print_debug("[DEBUG]: Starved to death")
		remove_from_group("Herbivores")
		alive = false
		var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		tween.tween_property(self, "scale", Vector3.ZERO, 0.6)
		var timer = get_tree().create_timer(0.6)
		await timer.timeout
		timer = null
		queue_free()
	elif energy >= 2:
#		if energy >= 3:
#			var i = randi_range(1, 8)
#			if i == 1:
#				spawn(prefabTree, position, "CoconutTree")
			for i in range(energy - 1):
				spawn(prefabChild, position, "Herbivore")
	#		print_debug("[DEBUG]: Reproduced")
	energy = 0
#		print_debug("[DEBUG]: Survived")

func detected(predator, food):
	predatorList = predator
	foodList = food

func hunt():
	if foodList == null: return

	var closest_food
	var closest_food_distance
	for i in foodList:
		if i == null: continue
		var current_food_distance = position.distance_to(i.global_position)
		if closest_food == null or current_food_distance < closest_food_distance:
			closest_food = i
			closest_food_distance = current_food_distance
	if closest_food: look_at(closest_food.global_transform.origin, Vector3.UP)

func flee():
	if predatorList == null: return
	
	var closest_predator
	var closest_predator_distance
	for i in predatorList:
		if i == null: continue
		var current_predator_distance = position.distance_to(i.global_position)
		if closest_predator == null or current_predator_distance < closest_predator_distance:
			closest_predator = i
			closest_predator_distance = current_predator_distance
	if closest_predator:
		look_at(closest_predator.global_transform.origin, Vector3.UP)
		rotation.y += PI

func wander():
	rotation.y = randf_range(-PI, PI)
	wanderTime = randf_range(1, 3)

func bounce():
	if position.x >= 14:
		position.x -= 0.05
		predatorList = null
		rotation.y = randf_range(-PI, PI)
		wanderTime = 3
	elif position.x <= -14:
		position.x += 0.05
		predatorList = null
		rotation.y = randf_range(-PI, PI)
		wanderTime = 3
	elif position.z >= 14:
		position.z -= 0.05
		predatorList = null
		rotation.y = randf_range(-PI, PI)
		wanderTime = 3
	elif position.z <= -14:
		position.z += 0.05
		predatorList = null
		rotation.y = randf_range(-PI, PI)
		wanderTime = 3

func randomPos():
	return Vector3(randf_range(-13, 13), 0, randf_range(-13, 13))

func spawn(entity, pos, stringName):
	var instance = entity.instantiate()
	instance.global_position = pos
	instance.rotation.y = randf_range(-PI, PI)
	add_child(instance)
	var child = get_node(stringName)
	remove_child(child)
	sim.add_child(child)



func _on_hitbox_component_body_entered(body):
	if !alive: return
	if body.is_in_group("PlantFoods"):
		body.queue_free()
		energy += 1
#		print_debug("[DEBUG]: current energy is " + str(energy))
