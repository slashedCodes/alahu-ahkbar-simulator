extends Control

func _ready():
	var fullscreen = GameManager.get_user_value("settings", "fullscreen")
	if fullscreen:
		if fullscreen == true: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		if fullscreen == false: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		GameManager.set_user_value("settings", "fullscreen", true)
			 
func switch():
	GameManager.goto_scene("res://Scenes/main_menu.tscn", false)
