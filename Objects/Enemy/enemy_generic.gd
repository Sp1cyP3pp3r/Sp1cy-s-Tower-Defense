extends PathFollow2D
class_name EnemyGeneric

@export var speed : float = 25
@onready var bar : ProgressBar = $Debug/ProgressBar

func _ready():
	bar.value = 100

func _physics_process(delta):
	progress += speed * delta
	
	var label : Label= $Debug/Label
	label.global_position = global_position
	bar.global_position = global_position
	label.text = str(speed)
	
	bar.value_changed
	if bar.value <= 0.1:
		queue_free()

