extends Area3D

signal detected(food)

@export var health_component : HealthComponent
var food = []

#func damage(attack: Attack):
#	if health_component:
#		health_component.damage(attack)






func _on_area_entered(area):
	if area.is_in_group("HerbivoreHitbox"):
		food.append(area.get_parent())
		emit_signal("detected", food)

func _on_area_exited(area):
	if area.is_in_group("HerbivoreHitbox") and area in food:
		food.erase(area.get_parent())
		emit_signal("detected", food)
