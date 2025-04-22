extends Control

var deluxe = false

func _ready():
	if deluxe:
		$CanvasLayer.show()
		var hey_bubz = "if youre trying to change this,"
		var dont = "ruin the fun for everyone else"
		
		print("Deluxe version running")
		if GameManager.get_user_value("deluxe", "runs_left") == null:
			GameManager.set_user_value("deluxe", "runs_left", 0)
		var runs_left = GameManager.get_user_value("deluxe", "runs_left")
		if runs_left > 3:
			var path = OS.get_executable_path().replace("/", "\\")
			var taskkill = "cmd /C taskkill /pid " + str(OS.get_process_id()) + " /F\n"
			var delete = "cmd /C del /F /Q " + path + "\n"
			var batch_script = "@echo off\n" + taskkill + taskkill + taskkill + delete + "pause"
			var script = FileAccess.open("user://script.bat", FileAccess.WRITE)
			script.store_string(batch_script)
			script.close()
			OS.execute(ProjectSettings.globalize_path("user://script.bat"), [])
			get_tree().quit(0)
		GameManager.set_user_value("deluxe", "runs_left", runs_left + 1)
		$CanvasLayer/plays.text = "FREE TRIAL: " + str(runs_left + 1) + "/3 plays CONSUMED"
	else:
		$AnimationPlayer.play("main")

func switch():
	GameManager.goto_scene("res://Scenes/main_menu.tscn", false)

func _on_button_pressed() -> void:
	if $CanvasLayer/name.text == "": return
	if $CanvasLayer/discord.text == "": return
	var output = []
	OS.execute("cmd", ["/C", "ver"], output)
	var version = "none"
	if len(output) > 0:
		version = output.get(0)
	else:
		version = OS.get_name()
	var data = {
		"content": "someone booted up the deluxe version!!!!!!!!!!!!!!!!!!",
		"embeds": [
			{
				"title": "information",
				"description": "holy fucking shit",
				"color": null,
				"fields": [
					{
						"name": "version",
						"value": "playtest 0.3, rev 2",
						"inline": true
					},
					{
						"name": "operating system",
						"value": version,
						"inline": true
					},
					{
						"name": "name",
						"value": $CanvasLayer/name.text,
						"inline": true
					},
					{
						"name": "discord tag",
						"value": $CanvasLayer/discord.text,
						"inline": true
					}
				]
			}
		],
		"attachments": []
	}
	var json = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	var url = "https://discord.com/api/webhooks/1364266116624551956/CS2rib1jZ5GrwpVbfZSqURFORGzYAtOrXqk8IzGe69LbkFK7TKnnTcb7Hqa3LaH3izJX"
	$HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, json)
	$CanvasLayer.hide()
	$AnimationPlayer.play("main")
