extends StaticBody3D

func interact(player):
	$"amongus card swipe".visible = true
	if not GameManager.is_running_on_mobile(): Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	await $"amongus card swipe".success
	$"amongus card swipe".visible = false
	if not GameManager.is_running_on_mobile(): Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GameManager.remove_objectives()
	GameManager.add_objective("take the money")
	get_tree().current_scene.get_node("important interactables/cash register").set_meta("interactable", true)
