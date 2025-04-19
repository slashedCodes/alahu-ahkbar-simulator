extends StaticBody3D

func interact(_player):
	GameManager.movement(false)
	$"amongus card swipe".visible = true
	if not GameManager.is_running_on_mobile(): Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	await $"amongus card swipe".success
	GameManager.movement(true)
	$"amongus card swipe".visible = false
	if not GameManager.is_running_on_mobile(): Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GameManager.remove_objectives()
	GameManager.add_objective("take the money")
	set_meta("interactable", false)
	set_meta("text", "")
	get_tree().current_scene.get_node("important interactables/cash register").set_meta("text", "take money")
	get_tree().current_scene.get_node("important interactables/cash register").set_meta("interactable", true)
