extends PathFollow2D
class_name EnemyGeneric

@export var stats : EnemyStats
@onready var health_node = $Health

signal enemy_death(enemy) # Need to change??

func _physics_process(delta):
	progress += stats.speed * delta
	
	var label : Label= $Debug/Label
	label.global_position = global_position
	label.text = str(stats.speed)

func death(_source):
	enemy_death.emit(self)
	queue_free()
