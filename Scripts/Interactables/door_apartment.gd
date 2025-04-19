extends StaticBody3D

func interact(player):
	if get_meta("text") == "nuh uh":
		$locked.play()
		await $locked.finished
		return
	
	get_owner().get_node("TransitionScreen").fade_to_black() # DOESNT WORK???
	GameManager.movement(false)
	$AudioStreamPlayer3D.play()
	await $AudioStreamPlayer3D.finished
	GameManager.movement(true)
	GameManager.goto_scene("res://Scenes/Gas Station Cutscene.tscn", false)
