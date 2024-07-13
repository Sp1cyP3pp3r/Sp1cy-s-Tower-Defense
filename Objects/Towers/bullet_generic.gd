extends Area2D
class_name Bullet

@export var custom_effects : CreateEffects
@export var stats : BulletStats

signal bullet_destroyed
signal effects_applied(effects : Array[Effect])

func _physics_process(delta):
	global_position += stats.speed * transform.x * delta


func hit_enemy(object):
	if object is EnemyGeneric:
		var enemy = object
		apply_effects(enemy)
		enemy.health_node.receive_damage(stats.damage, self)
	destroy()

func destroy():
	bullet_destroyed.emit()
	queue_free()

func apply_effects(game_object):
	if custom_effects:
		var applied_effects = custom_effects.add_effects(game_object)
		effects_applied.emit(applied_effects)
