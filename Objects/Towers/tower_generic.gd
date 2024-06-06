extends StaticBody2D
class_name TowerGeneric

enum AIM_MODE {First, Last, Near, Far, Random, Strong, Weak}

@export var stats : TowerStats
@export var current_aim_mode : AIM_MODE = AIM_MODE.First
@export var tower_gun : Sprite2D
@export var no_wall_raycast : RayCast2D
@export var reload_timer : Timer

var enemies_in_viewcone : Array[EnemyGeneric] = []
var gunpoints_array : Array[Gunpoint] = []

signal aim_mode_changed(aim_mode)

func _ready():
	update_gunpoints()


func _physics_process(delta):
	$Label.text = str(enemies_in_viewcone) + "\n" + str(assign_current_target(current_aim_mode, enemies_in_viewcone))

func add_enemy(area):
	var enemy = area.get_owner() if not area is EnemyGeneric else area
	if not enemies_in_viewcone.has(enemy):
		enemies_in_viewcone.append(enemy)
		#enemy.connect(&"enemy_death", Callable(self, &"remove_enemy"))
		#enemy.connect(&"became_hider", Callable(assign_current_target).bind(current_aim_mode, enemies_in_viewcone))
		#enemy.connect(&"tag_youre_it", Callable(assign_current_target).bind(current_aim_mode, enemies_in_viewcone))
	assign_current_target(current_aim_mode, enemies_in_viewcone)

func remove_enemy(area):
	var enemy = area.get_owner() if not area is EnemyGeneric else area
	if enemies_in_viewcone.has(enemy):
		enemies_in_viewcone.erase(enemy)
		#enemy.disconnect(&"enemy_death", Callable(self, &"remove_enemy"))
		#enemy.disconnect(&"became_hider", Callable(self, &"assign_current_target"))
		#enemy.disconnect(&"tag_youre_it", Callable(self, &"assign_current_target"))
	assign_current_target(current_aim_mode, enemies_in_viewcone)

func assign_current_target(aim : AIM_MODE, enemies : Array[EnemyGeneric]) -> EnemyGeneric:
	if enemies.is_empty():
		return
	var _pref_enemy = enemies[0]
	match aim:
		AIM_MODE.First:
			for enemy in enemies:
				if can_see_enemy(enemy):
					if enemy.progress_ratio > _pref_enemy.progress_ratio:
						_pref_enemy = enemy
		AIM_MODE.Last:
			for enemy in enemies:
				if can_see_enemy(enemy):
					if enemy.progress_ratio < _pref_enemy.progress_ratio:
						_pref_enemy = enemy
		AIM_MODE.Near:
			#for enemy in enemies:
				#if can_see_enemy(enemy):
					#var _pref_distance_to = global_position.distance_to(_pref_enemy.global_position)
					#var _enemy_distance_to = global_position.distance_to(enemy.global_position)
					#if _pref_distance_to > _enemy_distance_to:
						#_pref_enemy = enemy
					pass
				
		AIM_MODE.Far:
			#for enemy in enemies:
				#if can_see_enemy(enemy):
					#var _pref_distance_to = global_position.distance_to(_pref_enemy.global_position)
					#var _enemy_distance_to = global_position.distance_to(enemy.global_position)
					#if _pref_distance_to < _enemy_distance_to:
						#_pref_enemy = enemy
					pass
		AIM_MODE.Random:
				pass
		AIM_MODE.Strong:
			#for enemy in enemies:
				pass
		AIM_MODE.Weak:
			#for enemy in enemies:
				pass
	if can_see_enemy(_pref_enemy):
		return _pref_enemy
	else:
		return

func can_see_enemy(enemy) -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, enemy.global_position, 12)
	var result = space_state.intersect_ray(query)
	if not result.is_empty():
		return false
	if enemy.is_in_group(&"Hiders") and not stats.seeker:
		return false
	return true

func tower_fire():
	for gun in gunpoints_array:
		#gun.fire()
		pass

func update_gunpoints():
	gunpoints_array.clear()
	for child in tower_gun.get_children():
		if child is Gunpoint:
			gunpoints_array.append(child) 
