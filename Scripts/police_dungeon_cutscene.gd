extends Node3D

@onready var dialog = $dialog

# Called when the node enters the scene tree for the first time.
func _ready():
	if not get_tree().root.has_node("Main Menu"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		dialog.show()
		GameManager.movement(false)
		dialog.set_text("")
		await $eye_opening/AnimationPlayer.animation_finished
		await get_tree().create_timer(0.5).timeout
		
		
		dialog.set_text("i know who you are.... and i want you to tell me one thing.... did you kill those people...?")
		$"voice line 1".play()
		await $"voice line 1".finished
		dialog.clear_options()
		dialog.add_option("i was just performing for the show", option1)
		dialog.add_option("can i get a lawyer", option2)
		dialog.add_option("...", option3)
		dialog.show_options()
	else:
		$eye_opening.queue_free()

func option1():
	$"voice line 2".play()
	dialog.set_text("i don't believe you...")
	await $"voice line 2".finished
	GameManager.goto_scene("res://Scenes/hood_lie_detector.tscn", true)

func option2():
	$"idk can you".play()
	dialog.set_text("i dont know, can you?")
	await $"idk can you".finished
	GameManager.goto_scene("res://Scenes/courthouse_cutscene.tscn", false)

func option3():
	$"voice line 3".play()
	dialog.set_text("good...")
	await $"voice line 3".finished
	GameManager.goto_scene("res://Scenes/jail.tscn", false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
