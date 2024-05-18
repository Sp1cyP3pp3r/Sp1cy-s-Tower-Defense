extends Area2D
class_name Aura

@export var predefined_effects_array : Array[PackedScene]

@export_group("Custom Effect")
@export var can_create_custom_effect : bool = true
## Will create a custom effect with chosen properties in create_effect() function
@export var custom_effects_array : Array[EffectedProperties]

var enemies_in_area : Array = []

func _process(delta):
	$Label.text = str(enemies_in_area)


func create_custom_effect() -> Effect:
	var new_effect = Effect.new()
	for effected_properties in custom_effects_array:
		new_effect.properties_array.append(effected_properties.duplicate())
	return new_effect

func _on_area_entered(enemy_area):
	var array_of_effects : Array = []
	var enemy = enemy_area.get_owner()
	
	if can_create_custom_effect:
		var created_effect = create_custom_effect()
		array_of_effects.append(created_effect)
		enemy.add_child(created_effect)
	
	if not predefined_effects_array.is_empty():
		for predefined_effect in predefined_effects_array:
			if predefined_effect:
				var createad_effect = predefined_effect.instantiate()
				array_of_effects.append(createad_effect)
				enemy.add_child(createad_effect)
	
	var enemy_array : Array = [enemy, array_of_effects]
	enemies_in_area.append(enemy_array)

func create_and_assign_predefined_effects() -> void:
	var array_of_new_effect : Array[Effect] = []
	for effect_tscn in predefined_effects_array:
		array_of_new_effect.append(effect_tscn.instantiate())

func _on_area_exited(enemy_area):
	var enemy = enemy_area.get_owner()
	var array_to_delete = null
	for nested_array in enemies_in_area:
		if nested_array[0] == enemy:
			for effect in nested_array[1]:
				if effect != null:
					effect.queue_free()
			# It is best to not erase something in array while iterating over it (real)
			array_to_delete = nested_array
	if array_to_delete:
		enemies_in_area.erase(array_to_delete)
