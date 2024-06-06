extends Area2D
class_name Bullet

@export var custom_effects : CreateEffects
@export var damage : float = 12

var speed : float = 0

signal bullet_destroyed
signal effects_applied(effects : Array[Effect])

func _physics_process(delta):
	global_position += speed * rotation * delta

func _on_area_entered(area):
	if area.get_owner() is EnemyGeneric:
		var enemy = area.get_owner() as EnemyGeneric
		apply_effects(enemy)
		enemy.health_node.receive_damage(damage, self)
	destroy()

func destroy():
	bullet_destroyed.emit()
	queue_free()

func apply_effects(game_object):
	if custom_effects:
		var applied_effects = custom_effects.add_effects(game_object)
		effects_applied.emit(applied_effects)
