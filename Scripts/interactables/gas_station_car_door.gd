extends StaticBody3D

func interact(player):
	if get_meta("money"):
		GameManager.goto_scene("res://Scenes/Room part 2.tscn")
	else:
		GameManager.goto_scene("res://Scenes/Broke ahh room.tscn", false)
