extends Node

@onready var root = get_tree().current_scene
@onready var player = null
@onready var objectives = null

func _ready():
	refresh_vars()

func save_scene(scene):
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	save_game.store_line(scene)

func get_last_scene():
	if FileAccess.file_exists("user://savegame.save"):
		var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
		return save_game.get_line()
	else:
		save_scene("res://Scenes/Room.tscn")
		return "res://Scenes/Room.tscn" # New game scene


func refresh_vars():
	root = get_tree().current_scene
	if root and root.has_node("Player"):
		player = root.get_node("Player")
		objectives = player.get_node("Neck/Camera3D/objectives")

func add_objective(text):
	refresh_vars()
	var label = Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	var container = objectives.get_node("container")
	container.add_child(label)

func remove_objectives():
	refresh_vars()
	var container = objectives.get_node("container")
	for label in container.get_children():
		label.queue_free()

func objectives_visible(state):
	refresh_vars()
	objectives.visible = state

func goto_scene(path):
	TransitionScreen.fade_to_black()
	await TransitionScreen.transitioned
	refresh_vars()
	save_scene(path)
	call_deferred("_deferred_goto_scene", path)
	TransitionScreen.fade_from_black()

func _deferred_goto_scene(path):
	get_tree().change_scene_to_file(path)