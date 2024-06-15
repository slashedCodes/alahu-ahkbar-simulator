extends Panel

func _on_respawn_pressed():
	get_tree().paused = false
	GameManager.goto_scene(get_tree().current_scene.scene_file_path)
	
