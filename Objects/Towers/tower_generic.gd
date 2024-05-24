extends StaticBody2D
class_name TowerGeneric

var enemy_array

func add_enemy(area):
	var enemy = area.get_owner as EnemyGeneric
