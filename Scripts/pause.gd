extends CanvasLayer

var previous_mouse_mode

func _ready():
	get_tree().paused = false

func _input(event):
	if event.is_action_pressed("pause"):
		await get_tree().create_timer(0.001).timeout # necesarry timeout
		hide()
		get_tree().paused = false
		
		if not GameManager.is_running_on_mobile(): Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if get_tree().current_scene.has_node("Player") and GameManager.is_running_on_mobile():
			get_tree().current_scene.get_node("Player/Neck/Camera3D/mobile controls").visible = true

func _on_resume_pressed():
	if not GameManager.is_running_on_mobile(): Input.mouse_mode = previous_mouse_mode
	get_tree().paused = false
	hide()

	if get_tree().current_scene.has_node("Player") and GameManager.is_running_on_mobile():
		get_tree().current_scene.get_node("Player/Neck/Camera3D/mobile controls").visible = true

func pause():
	#move_to_front()
	previous_mouse_mode = Input.mouse_mode
	if not GameManager.is_running_on_mobile(): Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	#visible = true
	show()
	
	if get_tree().current_scene.has_node("Player"):
		get_tree().current_scene.get_node("Player/Neck/Camera3D/mobile controls").visible = false
	
func _on_exit_pressed():
	get_tree().quit()

func _on_exit_to_menu_pressed():
	GameManager.goto_scene("res://Scenes/main_menu.tscn", false)

func _on_reset_pressed():
	if not GameManager.is_running_on_mobile(): Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	visible = false
	get_tree().reload_current_scene()
