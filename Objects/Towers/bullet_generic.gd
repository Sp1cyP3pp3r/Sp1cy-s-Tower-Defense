extends Area2D
class_name Bullet

@export var damage : float = 12

func _on_area_entered(area):
	if area.get_owner() is EnemyGeneric:
		var enemy = area.get_owner() as EnemyGeneric
		enemy.health_node.receive_damage(damage, self)
		
	destroy()

func destroy():
	queue_free()
