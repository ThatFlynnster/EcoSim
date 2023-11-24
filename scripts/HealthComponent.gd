extends Node3D
class_name HealthComponent

@export var LIFE := true

func _ready():
	LIFE = true

#func damage(attack: Attack):
#	get_parent().queue_free()
