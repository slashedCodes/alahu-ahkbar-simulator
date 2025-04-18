extends Node3D

var quicktime_scene = preload("res://Scenes/quicktime_event.tscn")
@onready var confidence_bar = $Camera3D/confidence
@onready var dialog = $Camera3D/dialog
@onready var time_bar = $Camera3D/time
var time_left = 1
var confidence = 1
var minigame = false

# Define possible keys for quicktime events with their corresponding display strings
var possible_keys = [
	{"key": KEY_A, "text": "A"},
	{"key": KEY_C, "text": "C"},
	{"key": KEY_D, "text": "D"},
	{"key": KEY_E, "text": "E"},
	{"key": KEY_F, "text": "F"},
	{"key": KEY_G, "text": "G"},
	{"key": KEY_H, "text": "H"},
	{"key": KEY_Q, "text": "Q"},
	{"key": KEY_R, "text": "R"},
	{"key": KEY_S, "text": "S"},
	{"key": KEY_T, "text": "T"},
	{"key": KEY_U, "text": "U"},
	{"key": KEY_V, "text": "V"},
	{"key": KEY_W, "text": "W"},
	{"key": KEY_X, "text": "X"},
	{"key": KEY_Y, "text": "Y"},
	{"key": KEY_Z, "text": "Z"},
]

# Added variables for QTE timing
var qte_cooldown = 0
var last_qte_time = 0

func _process(delta):
	if minigame:
		time_bar.visible = true
		confidence_bar.visible = true
		
		time_left -= 0.08 * delta
		time_left = max(time_left, 0)
		time_bar.scale = Vector2(time_left, time_bar.scale.y)
		if time_left == 0: time_fail()
		
		confidence -= 0.05 * delta
		confidence = max(confidence, 0)
		confidence_bar.scale = Vector2(confidence, confidence_bar.scale.y)
		if confidence == 0: confidence_fail()
		
		# Handle QTE cooldown
		qte_cooldown -= delta
		
		# Generate new quicktime events occasionally if cooldown has expired
		if qte_cooldown <= 0 and Time.get_ticks_msec() - last_qte_time > 500:
			generate_random_quicktime()
			
			# Set a random cooldown between 2-4 seconds before next QTE 
			qte_cooldown = randf_range(0.5, 1.5)
	else:
		time_bar.visible = false
		confidence_bar.visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if not get_tree().root.get_child(2).name == "Main Menu":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		dialog.visible = true
		dialog.clear_options()
		await get_tree().create_timer(2).timeout
		await show_cop_dialog("alright, did you kill those people cuh?", $audio/cop/alr_did_you_kill_those_people_cuh)
		
		dialog.add_option("DUHHH", duhhh)
		dialog.add_option("HELL NAW", hell_naw)
		dialog.add_option("idk what ur talking about", idk_what_ur_talking_about)
		dialog.show_options()

var time_fale = false
func time_fail():
	if time_fale: return
	minigame = false
	time_fale = true
	$Camera3D/pointer.visible = true
	$Camera3D/pointer/buzzer.play()
	jail()

var confidence_fale = false
func confidence_fail():
	if confidence_fale: return
	minigame = false
	confidence_fale = true
	confidence += 0.3
	$Camera3D/pointer.visible = true
	$Camera3D/pointer/buzzer.play()
	jail()


# New function to generate random quicktime events
func generate_random_quicktime():
	# Select a random key from the possible keys
	var random_key_entry = possible_keys[randi() % possible_keys.size()]
	var random_key = random_key_entry["key"]
	var key_text = random_key_entry["text"]
	
	# Generate random position within visible screen area
	var screen_size = get_viewport().get_visible_rect().size
	var random_x = randf_range(10, screen_size.x - 10)
	var random_y = randf_range(10, screen_size.y - 10)
	var random_position = Vector2(random_x, random_y)
	
	# Random time between 0.6 and 1.2 seconds
	var random_time = randf_range(0.6, 1.2)
	
	# Create the quicktime event
	add_quicktime(random_key, key_text, random_time, success, fail, random_position, Vector2(0.3, 0.2))

func add_quicktime(key, text: String, time: float, success: Callable, fail: Callable, position: Vector2, scale: Vector2):
	var qte = quicktime_scene.instantiate()
	add_child(qte)
	qte.set_key(key)
	qte.set_text(text)
	qte.set_time(time)
	qte.set_success_callback(success)
	qte.set_fail_callback(fail)
	qte.position = position
	qte.scale = scale

func detector_true():
	$"fucking_lie_detec/he lying".visible = false
	$"fucking_lie_detec/on FOENEM".visible = true
	return play_audio_and_wait($"audio/ON FOENEM")

func detector_false():
	$"fucking_lie_detec/he lying".visible = true
	$"fucking_lie_detec/on FOENEM".visible = false
	return play_audio_and_wait($"audio/YOU LYIN")

func hide_detector():
	$"fucking_lie_detec/he lying".visible = false
	$"fucking_lie_detec/on FOENEM".visible = false

# Helper function to play audio and wait for it to finish
func play_audio_and_wait(audio_node):
	audio_node.play()
	return audio_node.finished

# Helper function for common dialog sequence
func handle_dialog_sequence(player_audio, detector_result):
	time_left = 1
	dialog.clear_options()
	await play_audio_and_wait(player_audio)
	await get_tree().create_timer(1).timeout
	
	if confidence >= 0.7:
		if detector_result == "true":
			await detector_true()
		else:
			await detector_false()
	else:
		if detector_result == "true":
			await detector_false()
		else:
			await detector_true()
		
	hide_detector()

# Core functions
func success():
	confidence += 0.05

func fail():
	print("failed")

# Helper for showing cop dialog
func show_cop_dialog(text: String, audio_node):
	dialog.set_text(text)
	await play_audio_and_wait(audio_node)
	await get_tree().create_timer(0.5).timeout

# Helper for showing "you are dumb" dialog branch
func show_dumb_dialog():
	await show_cop_dialog("ok so you are dumb...", $audio/cop/ok_so_you_are_dumb)
	
	dialog.add_option("im insane", yes_i_plead_mental_insanity_sire)
	dialog.add_option("HELL NAW", hell_naw_jail)
	dialog.add_option("alzheimer?", i_got_the_alice_heimer)
	dialog.show_options()

# Helper for showing "osama bin laden" dialog branch
func show_osama_dialog():
	await show_cop_dialog("who's osama bin alden?", $audio/cop/whos_osama_bin_laden)
	
	dialog.add_option("i love him", hes_my_pookie_popstar)
	dialog.add_option("you retarded", aw_hell_na_jigsaw_you_dumb)
	dialog.add_option("i dont remember", actually_i_dont_remember)
	dialog.show_options()

# Exit outcomes
func jail():
	dialog.clear_options()
	await show_cop_dialog("AW HELL NA you goin to JAIL", $audio/cop/aw_hell_na_you_goin_to_JAIL)
	await get_tree().create_timer(1).timeout
	GameManager.goto_scene("res://Scenes/jail.tscn", false)

# First level options
func duhhh():
	await handle_dialog_sequence($audio/player/DUHH, "true")
	jail()

func hell_naw():
	minigame = true
	await handle_dialog_sequence($audio/player/hell_na, "false")
	
	await show_cop_dialog("you finna go to jail for LIFE  cuh", $audio/cop/you_finna_go_to_jail_for_LIFE_cuh)
	
	dialog.add_option("i dont feel like it", what_if_i_dont_feel_like_it)
	dialog.add_option("the ac unit did it", nahh_i_didnt_do_it_the_ac_unit_did_yk)
	dialog.add_option("im busy tonight", aw_hell_na_i_got_a_date_with_osama_bin_landen_tonight)
	dialog.show_options()

func idk_what_ur_talking_about():
	minigame = true
	await handle_dialog_sequence($audio/player/idk_what_ur_talking_about, "false")
	
	await show_cop_dialog("are you DUMB cuh? we finna SANDPAPER yo TEETH", $audio/cop/are_you_dumb_cuh_we_finna_sandpaper_yo_teeth)
	
	dialog.add_option('what is "teeth"', what_is_teeth)
	dialog.add_option("how am i gonna give teeth now?", aw_hell_na_how_am_i_gonna_give_bin_laden_teeth_then)
	dialog.add_option("the ac unit did it!!", i_mean_i_didnt_do_it_the_ac_unit_did)
	dialog.show_options()

# Second level options
func what_is_teeth():
	await handle_dialog_sequence($audio/player/what_is_teeth, "true")
	await show_dumb_dialog()

func aw_hell_na_how_am_i_gonna_give_bin_laden_teeth_then():
	await handle_dialog_sequence($audio/player/aw_hell_na_how_am_i_gonna_give_bin_laden_teeth_then, "false")
	await show_osama_dialog()

func i_mean_i_didnt_do_it_the_ac_unit_did():
	await handle_dialog_sequence($"audio/player/i_mean_i_didnt_do_it_____the ac unit did", "true")
	await show_dumb_dialog()

func what_if_i_dont_feel_like_it():
	await handle_dialog_sequence($audio/player/what_if_i_dont_feel_like_it, "true")
	jail()

func nahh_i_didnt_do_it_the_ac_unit_did_yk():
	await handle_dialog_sequence($audio/player/i_didnt_do_it_cuh_the_ac_unit_did_yk, "false")
	await show_dumb_dialog()

func aw_hell_na_i_got_a_date_with_osama_bin_landen_tonight():
	await handle_dialog_sequence($audio/player/aw_hell_na_i_got_a_date_with_bin_laden_tonight, "true")
	await show_osama_dialog()

# Third level options
func hes_my_pookie_popstar():
	await handle_dialog_sequence($audio/player/hes_my_pookie_popstar, "true")
	jail()

func aw_hell_na_jigsaw_you_dumb():
	await handle_dialog_sequence($audio/player/aw_hell_na_jigsaw_you_DUMB, "true")
	jail()

func actually_i_dont_remember():
	await handle_dialog_sequence($audio/player/actually_i_dont_remember, "false")
	await show_dumb_dialog()

func yes_i_plead_mental_insanity_sire():
	# This function was empty in the original
	pass

func hell_naw_jail():
	await handle_dialog_sequence($audio/player/hell_na, "true")
	jail()

func i_got_the_alice_heimer():
	# This function was empty in the original
	pass
