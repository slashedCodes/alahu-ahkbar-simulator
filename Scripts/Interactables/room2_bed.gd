extends StaticBody3D

@onready var anim_player := $fade/AnimationPlayer

func _ready():
	GameManager.remove_objectives()
	GameManager.objectives_visible(true)
	GameManager.add_objective("go to sleep")

func interact(camera: Camera3D):
	anim_player.play("sleep")
	GameManager.movement(false)
	
	await anim_player.animation_finished # wait for the anim to be finished
	if not GameManager.graphics_quality: camera.compositor.compositor_effects.get(0).enabled = true
	Engine.max_fps = 20
	
	var phone = $"../../apartment/furniture/phone"
	phone.visible = true
	
	GameManager.movement(true)
	GameManager.remove_objectives()
	GameManager.objectives_visible(true)
	GameManager.add_objective("pick up the phone baby")

	set_meta("interactable", false)
	set_meta("text", "")

	# make pc interactable
	var pc = $"../phone"
	pc.set_meta("text", "pickup the phone")
	pc.set_meta("interactable", true)
