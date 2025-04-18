extends StaticBody3D

func interact(_player):
	set_meta("text", "it's locked")
	set_meta("interactable", false)
	$AudioStreamPlayer3D.play()
	await $AudioStreamPlayer3D.finished
	set_meta("interactable", true)
	set_meta("text", "door")
