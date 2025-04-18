extends Node2D

# Card #

@onready var card = $id
var dragging = false
var offset = Vector2(0, 0)

func _on_drag_button_down():
	dragging = true
	offset = get_global_mouse_position() - card.global_position

func _on_drag_button_up():
	dragging = false

func _physics_process(delta):
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if dragging:
		card.position = get_global_mouse_position() - offset
		card.move_and_slide()

# Detector #

@onready var message = $"card swipe/message"
var success_var = false
signal success
var fail_messages = [
	"nope",
	"try again",
	"and again",
	"give up",
	"again!",
	"no lol",
	"you cant do it!",
	"give up already",
	"the cops are on yo ass",
	"wrong",
	"F"
]

func _on_detector_body_entered(body):
	var rng = RandomNumberGenerator.new()
	var num = rng.randf_range(1, 10)
	if num > 9.8 and not success_var:
		$"card swipe".visible = false
		$id.visible = false
		$Label.visible = true
		await get_tree().create_timer(2.0).timeout
		success.emit()
		message.text = "success"
		success_var = true
	elif not success_var:
		$AudioStreamPlayer.playing = false
		$AudioStreamPlayer.playing = true
		message.text = fail_messages[rng.randi_range(0, len(fail_messages) - 1)]
