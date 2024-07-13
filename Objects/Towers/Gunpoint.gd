extends Marker2D
class_name Gunpoint

@export var gun_stats : TowerStats
@export var bullet : PackedScene
@export var reload_timer : Timer
@onready var tower = get_owner()
# Code which spawns bullets or smth
var is_ready : bool = true
signal reloaded

func fire():
	if is_ready:
		var fired_bullet = bullet.instantiate()
		fired_bullet.global_position = global_position
		fired_bullet.global_rotation = global_rotation
		fired_bullet.stats.speed = tower.stats.bullet_speed + gun_stats.bullet_speed
		fired_bullet.stats.damage = tower.stats.damage + gun_stats.damage
		get_tree().root.add_child(fired_bullet)
		
		var _reload_time = tower.stats.firerate + gun_stats.firerate
		reload_timer.start(_reload_time)
		is_ready = false
	else:
		return reload_timer.time_left

func reload() -> void:
	is_ready = true
	reloaded.emit(self)
