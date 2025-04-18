extends StaticBody3D

var open = false
@onready var door = get_parent()
@onready var angle = door.rotation_degrees

func _ready():
	if not has_meta("interactable") and not has_meta("text"):
		set_meta("interactable", true)
		set_meta("text", "open")

func interact(player):
	if open:
		if has_node("AudioStreamPlayer3D"):
			$AudioStreamPlayer3D.play()
		set_meta("text", "open")
		door.rotation_degrees = angle
	else:
		if has_node("AudioStreamPlayer3D"):
			$AudioStreamPlayer3D.play()
		set_meta("text", "close")
		door.rotation_degrees = Vector3(0, 0, 100)
	open = !open
