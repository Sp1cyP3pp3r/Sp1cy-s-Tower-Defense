extends PathFollow2D
class_name EnemyGeneric

@export var stats : EnemyStats
@onready var health_node = $Health


func _physics_process(delta):
	progress += stats.speed * delta
	
	var label : Label= $Debug/Label
	label.global_position = global_position
	label.text = str(stats.speed)

func death(_source):
	queue_free()
