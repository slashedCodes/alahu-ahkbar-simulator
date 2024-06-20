extends Control

func _ready():
	await get_tree().create_timer(1.0).timeout
	$Video.play()
	await $Video.finished
	GameManager.goto_scene("res://Scenes/main_menu.tscn", false)
