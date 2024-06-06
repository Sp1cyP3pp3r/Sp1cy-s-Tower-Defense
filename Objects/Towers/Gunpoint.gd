extends Marker2D
class_name Gunpoint

@export var bullet : PackedScene
# Code which spawns bullets or smth

func fire(current_target):
	var fired_bullet = bullet.instantiate()
	fired_bullet.global_position = global_position
	
	fired_bullet.speed = 100
	fired_bullet.direction 
	
	get_tree().root.add_child(fired_bullet)
	
