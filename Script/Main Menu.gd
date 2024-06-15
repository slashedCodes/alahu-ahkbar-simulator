extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var last_scene = GameManager.get_last_scene()
	print(last_scene)
	var scene_instance = load(last_scene).instantiate()

	if scene_instance.has_node("menu_camera"):
		var scene_camera = scene_instance.get_node("menu_camera")
		scene_camera.current = true
	
	get_tree().current_scene.add_child(scene_instance)
