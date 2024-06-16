extends Panel

func _ready():
	get_tree().paused = false

func _input(event):
	if event.is_action_pressed("pause"):
		await get_tree().create_timer(0.001).timeout # necesarry timeout
		visible = false
		get_tree().paused = false
		
		if not GameManager.is_running_on_mobile(): Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if get_tree().current_scene.has_node("Player"):
			get_tree().current_scene.get_node("Player/Neck/Camera3D/mobile controls").visible = true

func _on_resume_pressed():
	if not GameManager.is_running_on_mobile(): Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	visible = false

	if get_tree().current_scene.has_node("Player"):
		get_tree().current_scene.get_node("Player/Neck/Camera3D/mobile controls").visible = true

func pause():
	if not GameManager.is_running_on_mobile(): Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	visible = true
	
	if get_tree().current_scene.has_node("Player"):
		get_tree().current_scene.get_node("Player/Neck/Camera3D/mobile controls").visible = false
	
func _on_exit_pressed():
	get_tree().quit()

func _on_exit_to_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_reset_pressed():
	if not GameManager.is_running_on_mobile(): Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	visible = false
	get_tree().reload_current_scene()
