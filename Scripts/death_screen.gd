extends Panel

func _on_respawn_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	if not GameManager.is_running_on_mobile():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _on_respawn_2_pressed():
	GameManager.goto_scene("res://Scenes/main_menu.tscn", false)

func _on_exit_pressed():
	get_tree().quit()
