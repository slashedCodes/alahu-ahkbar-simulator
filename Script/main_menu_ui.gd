extends Panel

func _on_play_pressed():
	GameManager.goto_scene(GameManager.get_last_scene())

func _on_quit_pressed():
	get_tree().quit()
