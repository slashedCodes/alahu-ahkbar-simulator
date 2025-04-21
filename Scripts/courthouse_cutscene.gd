extends Node2D

func _on_video_stream_player_finished() -> void:
	GameManager.goto_scene("res://Scenes/jail.tscn", false)
