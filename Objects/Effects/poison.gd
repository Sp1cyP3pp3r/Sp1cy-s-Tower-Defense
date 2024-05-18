extends Effect

func apply_special_effect() -> void:
	effected_game_object.health_node.receive_damage(1, self)
