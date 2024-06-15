extends Control

func _on_room_pressed():
	GameManager.goto_scene("res://Scenes/Room.tscn")

func _on_gas_station_cutscene_pressed():
	GameManager.goto_scene("res://Scenes/Gas Station Cutscene.tscn")

func _on_gas_station_pressed():
	GameManager.goto_scene("res://Scenes/Gas Station.tscn")
