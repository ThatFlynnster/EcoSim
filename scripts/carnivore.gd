extends CharacterBody3D

@onready var nav: NavigationAgent3D = $NavigationAgent3D

var speed = 3.0
var size = 1.0
var view = 1.0

const speedRange = Vector2(1.0, 4.0)
const sizeRange = Vector2(0.5, 2.0)
const viewRange = Vector2(0.5, 2.0)

const prefabChild = preload("res://entities/carnivore.tscn")
const prefabTree = preload("res://entities/coconut_tree.tscn")
var sim
var viewRangeComponent
var foodlist

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

func _process(delta):
	if !alive: return
#	if foodlist:
#
	if wanderTime > 0: wanderTime -= delta
	else: wander()

func day_passed():
	if energy == 0:
#		print_debug("[DEBUG]: Starved to death")
		remove_from_group("Carnivores")
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
			spawn(prefabChild, position, "Carnivore")
	#		print_debug("[DEBUG]: Reproduced")
	energy -= 1
#		print_debug("[DEBUG]: Survived")

func detected(food):
	foodlist = food

func hunt():
	if foodlist == null: return
	
	var closest_food
	var closest_food_distance
	for i in foodlist:
		if i == null: continue
		var current_food_distance = position.distance_to(i.global_position)
		if closest_food == null or current_food_distance < closest_food_distance:
			closest_food = i
			closest_food_distance = current_food_distance
	if closest_food and energy < 2: look_at(closest_food.global_transform.origin, Vector3.UP)

func wander():
#	direction = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
#	direction = -global_transform.basis.z
	rotation.y = randf_range(-PI, PI)
	wanderTime = randf_range(1, 3)

func bounce():
	if position.x >= 14:
		position.x -= 0.05
		rotation.y = randf_range(-PI, PI)
		wanderTime = 3
	elif position.x <= -14:
		position.x += 0.05
		rotation.y = randf_range(-PI, PI)
		wanderTime = 3
	elif position.z >= 14:
		position.z -= 0.05
		rotation.y = randf_range(-PI, PI)
		wanderTime = 3
	elif position.z <= -14:
		position.z += 0.05
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

func _on_hitbox_component_area_entered(area):
	if !alive or energy >= 2: return
	if area.is_in_group("HerbivoreHitbox"):
		area.get_parent().remove_from_group("Herbivores")
		foodlist.erase(area.get_parent())
		area.get_parent().queue_free()
		
		energy += 1
