extends Camera3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if GameManager.is_running_on_mobile():
		$"mobile controls".visible = true

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		$"Pause Screen".pause()

func _on_skip_pressed():
	GameManager.goto_scene("res://Scenes/Gas Station.tscn")
