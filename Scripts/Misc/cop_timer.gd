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
		var root = get_tree().current_scene
		root.get_node("the j").queue_free()
		root.get_node("light").queue_free()
		root.get_node("intense music").playing = false
		await get_tree().create_timer(1.0).timeout
		root.get_node("freddy").play()
