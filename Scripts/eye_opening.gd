extends Node2D

func _ready():
	if get_tree().root.has_node("Main Menu"):
		queue_free()
