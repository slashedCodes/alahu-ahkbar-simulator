extends Panel

var master_bus = AudioServer.get_bus_index("Master")
var reverb_bus = AudioServer.get_bus_index("Reverb")

func _on_play_pressed():
	get_tree().paused = false
	if GameManager.is_running_on_mobile():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GameManager.goto_scene(GameManager.get_last_scene())

func _on_quit_pressed():
	get_tree().quit()

func _on_new_game_pressed():
	GameManager.goto_scene("res://Scenes/shader_compilation.tscn", false)
	if GameManager.is_running_on_mobile():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if GameManager.get_user_value("settings", "low_detail"): 
		$settings/graphics.button_pressed = GameManager.get_user_value("settings", "low_detail")
		GameManager.set_low_detail(GameManager.get_user_value("settings", "low_detail"))
	else: 
		GameManager.set_low_detail(false)
		GameManager.set_user_value("settings", "low_detail", false)
		$settings/graphics.button_pressed = false
	
	if GameManager.get_user_value("settings", "fullscreen"):
		$settings/fullscreen.button_pressed = GameManager.get_user_value("settings", "fullscreen")
	else:
		$settings/fullscreen.button_pressed = true
		
	$settings/volume.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus))
	if GameManager.is_running_on_mobile():
		$settings/graphics.hide()
		GameManager.set_user_value("settings", "low_detail", true)
		GameManager.set_low_detail(true)

func _on_settings_pressed() -> void:
	$menu.hide()
	$settings.show()

func _on_back_pressed() -> void:
	$menu.show()
	$settings.hide()

func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))
	AudioServer.set_bus_volume_db(reverb_bus, linear_to_db(value))
	GameManager.set_user_value("settings", "volume", value)

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	GameManager.set_user_value("settings", "fullscreen", toggled_on)
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_graphics_toggled(toggled_on: bool) -> void:
	GameManager.set_low_detail(toggled_on)
	GameManager.set_user_value("settings", "low_detail", toggled_on)
