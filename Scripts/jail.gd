extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.remove_objectives()
	GameManager.objectives_visible(true)
	GameManager.add_objective("escape jail")
	$Timer.start()

func _on_timer_timeout():
	$Control.visible = true
	$Control/VideoStreamPlayer.play()

func _on_video_stream_player_finished():
	$Control.visible = false
	$scream.play()
	GameManager.die("you got touched")
