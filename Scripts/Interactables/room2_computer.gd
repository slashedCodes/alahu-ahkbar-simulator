extends StaticBody3D

@onready var audio_pickup = $"../sleep/fade/pick up the phone baby"
@onready var audio_alarm = $"../sleep/fade/alarm"
var player = null

func interact(player_cam):
	player = player_cam
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$ui.visible = true
	GameManager.movement(false)

func _on_decline_pressed():
	if not GameManager.is_running_on_mobile(): 
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	audio_pickup.playing = false
	audio_alarm.playing = false
	$ui.visible = false
	
	GameManager.movement(true)
	GameManager.remove_objectives()
	GameManager.add_objective("go back to sleep")
	
	set_meta("interactable", false)
	set_meta("text", "")
	
	var sleep = $"../sleep"
	sleep.set_meta("interactable", true)
	sleep.set_meta("text", "go back to sleep")
	
	await get_tree().create_timer(4.5).timeout
	
	# kill the player
	
	var player_body = player.get_parent().get_parent()
	$boom.playing = true
	
	var sleep_ui = $"../sleep/fade"
	sleep_ui.visible = false
	
	player_body.die()
	

func _on_answer_pressed():
	$ui/calling.visible = true
	$ui/decline.visible = false
	$ui/answer.visible = false
	$ui/freakbob.visible = false
	
	audio_pickup.playing = false
	audio_alarm.playing = false
	
	$"line 1".playing = true
	await $"line 1".finished
	$ui/choice.visible = true

func _on_yes_pressed():
	$ui/choice.visible = false
	$"line 2".playing = true
	await $"line 2".finished
	
	if not GameManager.is_running_on_mobile():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	$ui.visible = false
	$"hang up".playing = true
	
	set_meta("interactable", false)
	set_meta("text", "")
	
	GameManager.movement(true)
	GameManager.remove_objectives()
	GameManager.objectives_visible(true)
	GameManager.add_objective("exit apartment")
	
func _on_no_pressed():
	$ui.visible = false
	$"hang up".playing = true
	
	if not GameManager.is_running_on_mobile():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	GameManager.movement(true)
	GameManager.remove_objectives()
	GameManager.add_objective("go back to sleep")
	
	set_meta("interactable", false)
	set_meta("text", "")
	
	var sleep = $"../sleep"
	sleep.set_meta("interactable", true)
	sleep.set_meta("text", "go back to sleep")
	
	await $"hang up".finished
	
	
	
	await get_tree().create_timer(4.5).timeout
	
	# kill the player
	var player_body = player.get_parent().get_parent()
	$boom.playing = true
	
	var sleep_ui = $"../sleep/fade"
	sleep_ui.visible = false
	player_body.die()
