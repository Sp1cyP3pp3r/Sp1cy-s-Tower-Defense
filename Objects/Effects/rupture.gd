extends Effect

func discard_effects():
	super.discard_effects()
	effected_game_object.health_node.receive_damage(10.5, self)

