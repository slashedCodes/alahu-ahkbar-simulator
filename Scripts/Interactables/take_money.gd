extends StaticBody3D

func interact(player):
	$AudioStreamPlayer3D.playing = false
	$AudioStreamPlayer3D.playing = true
	
	GameManager.remove_objectives()
	GameManager.add_objective("get to the car")
	
	var door = get_tree().current_scene.get_node("important interactables/car door")
	door.set_meta("money", true)
	set_meta("interactable", false)
	set_meta("text", "")
