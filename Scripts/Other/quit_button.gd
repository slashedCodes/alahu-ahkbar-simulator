extends Button

func _on_pressed():
	get_tree().quit()

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
