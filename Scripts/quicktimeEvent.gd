extends Node2D

@onready var outline := $Outline
@onready var qte := $qte
@onready var label := $qte/Label
@onready var timer := $Timer
var initial_time = 0
var success_callback: Callable
var fail_callback: Callable
var keycode = KEY_0

func set_time(time):
	timer.wait_time = time

func set_text(text):
	label.text = text

func set_key(key):
	keycode = key

func set_success_callback(cbk):
	success_callback = cbk

func set_fail_callback(cbk):
	fail_callback = cbk

var failed = false
func fail():
	if not failed:
		failed = true
		qte.self_modulate = Color(255, 0, 0)
		fail_callback.call()
		await get_tree().create_timer(1).timeout
		queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_time = timer.wait_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
var min_scale = 0.334
var max_scale = 1.304
func _process(delta):
	if timer.time_left <= 0:
		fail()
	else:
		if Input.is_key_pressed(keycode):
			success_callback.call()
			queue_free()
		
		var final_scale = Vector2(min_scale, min_scale)
		var initial_scale = Vector2(max_scale, max_scale)
		var progress = timer.time_left / initial_time
		
		# Set the scale directly based on progress
		outline.scale = initial_scale.lerp(final_scale, 1.0 - progress)
		


func _on_touch_screen_button_pressed():
	if timer.time_left > 0:
		success_callback.call()
