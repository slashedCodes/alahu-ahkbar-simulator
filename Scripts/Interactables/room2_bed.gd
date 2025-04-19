extends StaticBody3D

@onready var anim_player := $fade/AnimationPlayer

func _ready():
	GameManager.remove_objectives()
	GameManager.objectives_visible(true)
	GameManager.add_objective("go to sleep")

func interact(_player):
	anim_player.play("sleep")
	GameManager.movement(false)
	
	await anim_player.animation_finished # wait for the anim to be finished
	
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
