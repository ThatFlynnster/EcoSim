extends Area3D

signal detected(predator)

@export var health_component : HealthComponent
var predator = []
var food = []

#func damage(attack: Attack):
#	if health_component:
#		health_component.damage(attack)






func _on_area_entered(area):
	if area.is_in_group("CarnivoreHitbox"):
		predator.append(area.get_parent())
		emit_signal("detected", predator, food)

func _on_area_exited(area):
	if area.is_in_group("CarnivoreHitbox") and area in predator:
		predator.erase(area.get_parent())
		emit_signal("detected", predator, food)

func _on_body_entered(body):
	if body.is_in_group("PlantFoods"):
		food.append(body)
		emit_signal("detected", predator, food)

func _on_body_exited(body):
	if body.is_in_group("PlantFoods") and body in food:
		food.append(body)
		emit_signal("detected", predator, food)
