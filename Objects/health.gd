extends Node
class_name Health

@export var parent : Node 

signal hp_changed(difference : float)
signal damaged(amount_dealt : float, original_amount : float, source_of_damage : Node)
signal healed(amount_healed : float, original_amount : float, source_of_healing : Node)
signal final_blow(killer : Node)

func _physics_process(delta):
	%ProgressBar.value = parent.stats.current_hp
	$Node2D.global_position = owner.global_position
	$Node2D/Armor/Label.text = str(parent.stats.damage_resistance)
	$Node2D/Lesser/Label.text = str(parent.stats.healing_resistance)



func _ready():
	parent.stats.current_hp = parent.stats.max_hp

func change_health(amount : float, source : Node) -> void:
	parent.stats.current_hp += amount
	parent.stats.current_hp = clamp(parent.stats.current_hp, 0, parent.stats.max_hp)
	hp_changed.emit(amount)
	if parent.stats.current_hp <= 0.1:
		final_blow.emit(source)

func receive_damage(amount : float, source : Node) -> void:
	if amount <= 0:
		return
	var mitigated_damage
	if parent.stats.damage_resistance >= 0:
		mitigated_damage = amount * (100 / (100 + parent.stats.damage_resistance))
	else:
		mitigated_damage = amount * (2 - (100 / (100 - parent.stats.damage_resistance)))
	change_health(-mitigated_damage, source)
	damaged.emit(mitigated_damage, amount, source)

func receive_healing(amount : float, source : Node) -> void:
	if amount <= 0:
		return
	var mitigated_healing
	if parent.stats.healing_resistance >= 0:
		mitigated_healing = amount * (100 / (100 + parent.stats.healing_resistance))
	else:
		mitigated_healing = amount * (2 - (100 / (100 - parent.stats.healing_resistance)))
	change_health(mitigated_healing, source)
	healed.emit(mitigated_healing, amount, source)
