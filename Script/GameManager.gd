extends Node

@onready var root = get_tree().current_scene
@onready var transition_screen = get_tree().root.get_node("/root/TransitionScreen")
@onready var player = root.get_node("Player")
@onready var objectives = player.get_node("Neck/Camera3D/objectives")

func add_objective(text):
	var label = Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	var container = objectives.get_node("container")
	container.add_child(label)

func remove_objectives():
	var container = objectives.get_node("container")
	for label in container.get_children():
		label.queue_free()

func objectives_visible(state):
	objectives.visible = state

func goto_scene(path):
	transition_screen.fade_to_black()
	await transition_screen.transitioned
	call_deferred("_deferred_goto_scene", path)
	transition_screen.fade_from_black()

var current_scene = null

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func _deferred_goto_scene(path):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	
