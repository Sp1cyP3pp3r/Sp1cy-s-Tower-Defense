extends CharacterBody2D
class_name EnemyGeneric

@export var stats : EnemyStats
@export var health_node : Health
@onready var path_follow = get_owner()

signal enemy_death(enemy) # Need to change??
signal became_hider
signal tag_youre_it # No more hider

var is_dead : bool = false

func _physics_process(delta):
	path_follow.progress += stats.speed * delta
	
	var label : Label= $"../Debug/Label"
	var label_hds : Label = $"../Debug/Label2"
	label.global_position = global_position
	label_hds.global_position = global_position + Vector2(0,8)
	label.text = str(stats.speed)
	label_hds.text = str(get_groups())

func death(_source):
	enemy_death.emit(self)
	is_dead = true
	owner.queue_free()

func hide_and_seek(hider : bool) -> void:
	if hider:
		if not is_in_group(&"Hiders"):
			add_to_group(&"Hiders")
			became_hider.emit()
		else:
			return
	else:
		if is_in_group(&"Hiders"):
			remove_from_group(&"Hiders")
			tag_youre_it.emit()
		else:
			return

func get_progress() -> float:
	return owner.progress

func get_progress_ratio() -> float:
	return owner.progress_ratio
