extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	var last_scene = GameManager.get_last_scene()
	var scene_load
	if last_scene == null:
		$"Main Menu UI/menu/play".disabled = true
		scene_load = load("res://Scenes/Room.tscn")
	else:
		scene_load = load(last_scene)

	var scene_instance = null
	if scene_load:
		scene_instance = scene_load.instantiate()
	else:
		GameManager.goto_scene("res://Scenes/save_change_menu.tscn")
		return

	if scene_instance.has_node("menu_camera"): scene_instance.get_node("menu_camera").current = true
	if scene_instance.has_node("Player"): scene_instance.get_node("Player").queue_free()
	
	get_tree().current_scene.add_child(scene_instance)
	get_tree().paused = true
