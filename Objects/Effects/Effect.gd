extends Node
class_name Effect

@export var properties_array : Array[EffectedProperties]

var effected_enemy : EnemyGeneric

func _enter_tree():
	var _i : int = 0
	for property in properties_array:
		properties_array[_i] = property.duplicate(true)
		_i += 1

func _ready():
	if not effected_enemy: # Если цель дебаффа не назначена, будет назначен родитель
		effected_enemy = get_parent()
	apply_effects([])
	pass

func _exit_tree():
	discard_effects()
	pass


func apply_effects(applied_properties : Array[String]) -> void:
	var apply_all_properties : bool = false
	if applied_properties.is_empty():
		apply_all_properties = true
	
	print("\n" + str(effected_enemy.name) + " " + str(get_instance_id()) + "# APPLYING EFFECTS # " + str(applied_properties) + "\n")
	
	for property in properties_array:
		var property_name = property.property_name
		if property_name in applied_properties or apply_all_properties:
			if property_name in effected_enemy:
				var final_value : float
				var enemy_value : float = effected_enemy.get(property_name)
				var modificator : float = property.property_modificator
				
				print("\n" + str(effected_enemy.name) + " " + str(get_instance_id()) + " - initial value " + str(enemy_value))
				match property.modificator_mode:
					property.MOD_MODE.Addition:
						property.saved_value = modificator
						final_value = enemy_value + modificator
					property.MOD_MODE.Percentage:
						var perc : float = (enemy_value/100) * modificator
						property.saved_value = perc
						final_value = enemy_value + perc
				
				print(str(effected_enemy.name) + " " + str(get_instance_id()) + " - saved value " + str(property.saved_value))
				print(str(effected_enemy.name) + " " + str(get_instance_id()) + " - final value " + str(final_value))
				effected_enemy.set(property_name, final_value)

func discard_effects() -> void:
	if not is_queued_for_deletion():
		queue_free()
		return
	
	print("\n" + str(effected_enemy.name) + " " + str(get_instance_id()) + "### DISCARDING EFFECTS ###" + "\n")
	
	for property in properties_array:
		var property_name = property.property_name
		if property_name in effected_enemy:
			var enemy_value = effected_enemy.get(property_name)
			print(str(effected_enemy.name) + " " + str(get_instance_id()) + " - saved value (discard) " + str(property.saved_value))
			var final_value : float = enemy_value - property.saved_value
			effected_enemy.set(property_name, final_value)
			print(str(effected_enemy.name) + " " + str(get_instance_id()) + " - final value (discard) " + str(final_value))
	reapply_effects()

func reapply_effects() -> void:
	
	print("\n" + str(effected_enemy.name) + " " + str(get_instance_id()) + "### REAPPLYING EFFECTS ###" + "\n")
	
	var reapplied_effects : Array = []
	var reapplied_properties : Array[String] = []
	for property in properties_array:
		var reapplied_value : float = 0
		var property_name : String = property.property_name
		if property_name in effected_enemy and not property_name in reapplied_properties:
			if not property_name in reapplied_properties:
					reapplied_properties.append(property_name)
			var enemy_value = effected_enemy.get(property_name)
			for effect in effected_enemy.get_children():
				if effect is Effect and effect != self:
					var is_prompted : bool = false
					for eff_property in effect.properties_array:
						if eff_property.property_name == property_name:
							reapplied_value += eff_property.saved_value
							is_prompted = true
							print(str(effected_enemy.name) + " " + str(get_instance_id()) + " - saved value (reapply) of " + str(effect.get_instance_id()) + " " + str(eff_property.saved_value))
							
					if is_prompted:
						reapplied_effects.append(effect)
			
			if reapplied_value != 0:
				var final_value = enemy_value - reapplied_value
				effected_enemy.set(property_name, final_value)
				print(str(effected_enemy.name) + " " + str(get_instance_id()) + " - reapplied value " + str(reapplied_value))
				print(str(effected_enemy.name) + " " + str(get_instance_id()) + " - middle value (reapply) " + str(effected_enemy.get(property_name)))
				
			
	if not reapplied_effects.is_empty():
		for effect in reapplied_effects:
			if effect is Effect:
				effect.apply_effects(reapplied_properties)
		reapplied_effects.clear()
	
	# DEBUG
	for property in reapplied_properties:
		print(str(effected_enemy.name) + " " + str(get_instance_id()) + " - final value (reapply) " + str(effected_enemy.get(property)))
		
	
		
	#for effect in reapplied_effects:
		#if effect is Effect:
			#effect.apply_effects(properties_array)






