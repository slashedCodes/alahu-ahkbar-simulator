extends Camera3D

func _unhandled_input(event):
	if Input.is_action_just_pressed("jump"):
		switch()
	elif event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func switch():
	GameManager.goto_scene("res://Scenes/Gas Station.tscn")
