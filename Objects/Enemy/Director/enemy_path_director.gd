class_name Director
extends Node

func _physics_process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Engine.time_scale = 0.15
	else:
		Engine.time_scale = 1
