extends Control

var paused = false
var forwarding = false

func _input(event):
	if event.is_action_pressed("Pause"):
		paused = !paused
		forwarding = false
		Engine.time_scale = 1
		Engine.physics_ticks_per_second = 60
		get_tree().paused = not get_tree().paused
	if paused: return
	elif event.is_action_pressed("Fast Forward"):
		if !forwarding:
			forwarding = true
			Engine.time_scale = 20
			Engine.physics_ticks_per_second = 60 * 20
		else:
			forwarding = false
			Engine.time_scale = 1
			Engine.physics_ticks_per_second = 60
