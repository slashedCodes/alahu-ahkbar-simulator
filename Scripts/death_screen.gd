extends Panel

func _on_respawn_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_respawn_2_pressed():
	GameManager.goto_scene("res://Scenes/main_menu.tscn", false)
