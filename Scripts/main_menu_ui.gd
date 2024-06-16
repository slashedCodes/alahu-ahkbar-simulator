extends Panel

func _on_play_pressed():
	get_tree().paused = false
	if GameManager.is_running_on_mobile():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GameManager.goto_scene(GameManager.get_last_scene())

func _on_quit_pressed():
	get_tree().quit()

func _on_new_game_pressed():
	GameManager.goto_scene("res://Scenes/Room.tscn")
	if GameManager.is_running_on_mobile():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
