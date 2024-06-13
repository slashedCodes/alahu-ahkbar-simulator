extends StaticBody3D

func interact(player):
	# make door interactable
	get_owner().get_node("apartment/furniture/door/StaticBody3D").set_meta("text", "exit")
	get_owner().get_node("apartment/furniture/door/StaticBody3D").set_meta("interactable", true)
	
	GameManager.remove_objectives()
	GameManager.add_objective("exit apartment")
	
	get_parent().queue_free()
