extends StaticBody3D

func _ready():
	$"../../../../Player/Neck/Camera3D/inventory".add_item(get_node("Item"))
	GameManager.remove_objectives()
	GameManager.objectives_visible(true)
	GameManager.add_objective("buy chips from the gas station")
	$"../..".queue_free()
