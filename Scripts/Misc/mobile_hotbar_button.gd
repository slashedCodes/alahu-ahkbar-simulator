extends TouchScreenButton

func _pressed():
	var index = get_parent().get_index()
	var root = get_tree().current_scene
	if root.has_node("Player"):
		var inventory = root.get_node("Player/Neck/Camera3D/inventory")
		inventory.select_item(index)
