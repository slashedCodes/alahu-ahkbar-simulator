extends Panel

func _ready():
	get_tree().paused = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		await get_tree().create_timer(0.001).timeout # necesarry timeout
		visible = false
		get_tree().paused = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_resume_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	visible = false

func pause():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	visible = true
	
func _on_exit_pressed():
	get_tree().quit()
