extends Stats
class_name EnemyStats

@export var speed : float
@export var max_hp : float
var current_hp : float
@export var damage_resistance : float
@export var healing_resistance : float

enum PROPERTY_LIST {debug,speed,max_hp,current_hp,damage_resistance,healing_resistance}
# Probably need to find a better way to transliterate property list, idk
# 'debug' value is not to be used
