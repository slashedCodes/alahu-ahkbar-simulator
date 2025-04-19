extends Area3D

func _on_body_entered(body):
	if get_meta("enabled") == true and body.name == "Player":
		set_meta("enabled", false)
		GameManager.movement(false)
		%"cutscene camera".current = true
		%Camera3D.current = false
		GameManager.objectives_visible(false)
		$"../../Player".hide()
		%cutscene.play("cutscene")
		await %cutscene.animation_finished
		
		# go to next scene vro 💔
		GameManager.goto_scene("res://Scenes/police_dungeon_cutscene.tscn", true)
