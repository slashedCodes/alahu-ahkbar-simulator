extends StaticBody3D

func interact(_player):
	if get_meta("text") == "nuh uh":
		$locked.play()
		set_meta("text", "locked")
		set_meta("interactable", false)
		await $locked.finished
		set_meta("text", "nuh uh")
		set_meta("interactable", true)
		return
	
	get_owner().get_node("TransitionScreen").show()
	get_owner().get_node("TransitionScreen").fade_to_black()
	GameManager.movement(false)
	$AudioStreamPlayer3D.play()
	await $AudioStreamPlayer3D.finished
	GameManager.movement(true)
	GameManager.goto_scene("res://Scenes/Gas Station Cutscene.tscn", false)
