extends StaticBody3D

func interact(player):
	await get_tree().create_timer(0.7).timeout
	$pipe.playing = true
	$kill.visible = true
	await $pipe.finished
	$kill.visible = false
