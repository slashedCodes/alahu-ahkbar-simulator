extends Label

var started = false

func start():
	visible = true
	$Timer.start()
	started = true

func _process(delta):
	if $Timer.time_left > 0 and started:
		text = str(int($Timer.time_left)) + " seconds till the popo bust yo ass"
	elif started:
		text = "its joever lil bro"
		GameManager.goto_scene("res://Scenes/freddy.tscn", false)
