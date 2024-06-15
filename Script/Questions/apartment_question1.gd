extends Panel

func _on_kill_yourself_pressed():
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# add 4 objectives
	for i in range(4):
		GameManager.add_objective("JUMP OUT THE WINDOW")
	GameManager.objectives_visible(true) # show objectives
	
	$kill_yourself_music.playing = true # classical music
	
	# Make it so you cant exit
	
	get_owner().get_node("apartment/furniture/fridge/Refrigerator_door_01/fridge door").set_meta("interactable", false)
	get_owner().get_node("apartment/furniture/fridge/Refrigerator_door_01/fridge door").set_meta("text", "nuh uh")
	
	get_owner().get_node("apartment/furniture/door/StaticBody3D").set_meta("text", "nuh uh")
	get_owner().get_node("apartment/furniture/door/StaticBody3D").set_meta("interactable", false)
	get_owner().get_node("apartment/box/window").queue_free()


func _on_rob_gas_station_pressed():
	get_owner().get_node("apartment/furniture/door/StaticBody3D").set_meta("text", "nuh uh")
	get_owner().get_node("apartment/furniture/door/StaticBody3D").set_meta("interactable", false)
	
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GameManager.add_objective("get gun from fridge")
	GameManager.objectives_visible(true)
