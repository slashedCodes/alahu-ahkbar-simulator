extends Node

@onready var root = get_tree().current_scene
@onready var player = null
@onready var objectives = null
var low_detail = false

func _ready():
	var master_bus = AudioServer.get_bus_index("Master")
	var reverb_bus = AudioServer.get_bus_index("Reverb")
	var fullscreen = GameManager.get_user_value("settings", "fullscreen")
	if fullscreen:
		if fullscreen == true: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		if fullscreen == false: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		GameManager.set_user_value("settings", "fullscreen", true)
	
	if GameManager.get_user_value("settings", "volume"):
		AudioServer.set_bus_volume_linear(master_bus, GameManager.get_user_value("settings", "volume"))
		AudioServer.set_bus_volume_linear(reverb_bus, GameManager.get_user_value("settings", "volume"))
	else:
		GameManager.set_user_value("settings", "volume", db_to_linear(0.0))
	
	refresh_vars()

func die(message = "you die"):
	if player:
		player.die(message)

func movement(value):
	refresh_vars()
	if player:
		player.movement = value
		if is_running_on_mobile():
			player.get_node("Neck/Camera3D/mobile controls").visible = value

func save_scene(scene):
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	save_game.store_line(scene)

func get_last_scene():
	if FileAccess.file_exists("user://savegame.save"):
		var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
		return save_game.get_line()
	else:
		return null

func refresh_vars():
	root = get_tree().current_scene
	if root and root.has_node("Player"):
		player = root.get_node("Player")
		objectives = player.get_node("Neck/Camera3D/objectives")

func add_objective(text):
	if get_tree().current_scene.name == "Main Menu": return
	refresh_vars()
	var label = Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	var container = objectives.get_node("container")
	container.add_child(label)

func remove_objectives():
	if get_tree().current_scene.name == "Main Menu": return
	
	refresh_vars()
	var container = objectives.get_node("container")
	for label in container.get_children():
		label.queue_free()

func objectives_visible(state):
	if get_tree().current_scene.name == "Main Menu": return
	refresh_vars()
	objectives.visible = state

func goto_scene(path, save=true):
	TransitionScreen.fade_to_black()
	await TransitionScreen.transitioned
	refresh_vars()
	if save: save_scene(path)
	call_deferred("_deferred_goto_scene", path)
	TransitionScreen.fade_from_black()
	if not is_running_on_mobile():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _deferred_goto_scene(path):
	get_tree().change_scene_to_file(path)

func is_running_in_web_browser():
	if OS.get_name() == "Web":
		return true
	else:
		return false

func is_running_on_mobile():
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		return true
	else:
		#return true
		return false

func set_low_detail(value):
	low_detail = value

func set_user_value(section, value_name, value):
	var conf = ConfigFile.new()
	conf.load("user://settings.cfg")
	conf.set_value(section, value_name, value)
	conf.save("user://settings.cfg")

func get_user_value(section, value_name):
	var conf = ConfigFile.new()
	conf.load("user://settings.cfg")
	if not conf.has_section_key(section, value_name): return null
	return conf.get_value(section, value_name)
