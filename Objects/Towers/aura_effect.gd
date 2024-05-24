extends Area2D
class_name Aura

#@export var predefined_effects_array : Array[PackedScene]
#
#@export var can_create_custom_effect : bool = true
## Will create a custom effect with chosen properties in create_effect() function
#@export var custom_effects_array : Array[EffectedProperties]

@export var create_effects : CreateEffects

var enemies_in_area : Array = []

func _process(delta):
	$Label.text = str(enemies_in_area)

func add_enemy(area):
	var enemy = area.get_owner()
	var enemy_array : Array = [enemy, create_effects.add_effects(enemy)]
	enemy.connect(&"enemy_death", Callable(self, &"remove_enemy"))
	enemies_in_area.append(enemy_array)


func remove_enemy(area):
	var enemy = area.get_owner() if not area is EnemyGeneric else area
	var array_to_delete : Array
	for nested_array in enemies_in_area:
		if nested_array[0] == enemy:
			for effect in nested_array[1]:
				if effect != null:
					effect.queue_free()
			# It is best to not erase something in array while iterating over it (real)
			array_to_delete = nested_array
	enemies_in_area.erase(array_to_delete)

