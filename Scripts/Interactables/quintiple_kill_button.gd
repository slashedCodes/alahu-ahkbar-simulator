extends StaticBody3D

func _ready():
	GameManager.remove_objectives()
	GameManager.objectives_visible(true)
	GameManager.add_objective("eject the AC unit")
	GameManager.add_objective("(in the souvenirs apartment)")

func interact(player):
	set_meta("interactable", false)
	set_meta("text", "")
	$"button click".play()
	GameManager.remove_objectives()
	await get_tree().create_timer(0.3).timeout
	$scream.play()
	await get_tree().create_timer(0.4).timeout
	$pipe.play()
	$kill.visible = true
	%"blood car".visible = true
	%car.queue_free()
	await $pipe.finished
	GameManager.remove_objectives()
	GameManager.add_objective("go home")
	$kill.visible = false
	%cutscene_player.set_meta("enabled", true)
	
