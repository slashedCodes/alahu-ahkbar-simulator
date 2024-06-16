extends Camera3D

func _ready():
	if GameManager.is_running_on_mobile():
		$"mobile controls".visible = true

func _unhandled_input(event):
	if event is InputEventMouseButton and not GameManager.is_running_on_mobile():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event.is_action_pressed("pause"):
		$"Pause Screen".pause()

func switch():
	GameManager.goto_scene("res://Scenes/Gas Station.tscn")

func _on_skip_pressed():
	switch()
