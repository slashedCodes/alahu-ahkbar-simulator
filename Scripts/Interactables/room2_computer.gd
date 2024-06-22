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
	if not GameManager.is_running_on_mobile(): 
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	audio_pickup.playing = false
	audio_alarm.playing = false
	
	 # voice line plays here
