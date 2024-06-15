extends Panel

func _on_respawn_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
