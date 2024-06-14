extends StaticBody3D

func interact(player):
	GameManager.remove_objectives()
	GameManager.objectives_visible(true)
	GameManager.add_objective("buy chips from the gas station")
