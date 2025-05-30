extends CharacterBody3D
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var movement = true

@onready var neck := $Neck
@onready var camera := $Neck/Camera3D
@onready var gun_cam := $Neck/Camera3D
@onready var pause_screen := $"Neck/Camera3D/Pause Screen"

@onready var raycast = $Neck/Camera3D/RayCast3D
@onready var hand = $Neck/Hand
@onready var mobile_controls = camera.get_node("mobile controls")

@export_group("headbob")
@export var headbob_frequency := 2.0
@export var headbob_amplitude := 0.04
var headbob_time := 0.0

@onready var footstep_audio = $footstep
var footstep_can_play := true
var footstep_landed

func fire():
	if hand.get_child_count() > 0 and hand.get_child(0).is_in_group("gun"):
		hand.get_child(0).fire(raycast, self)

func die(message = "you die"):
	$"Neck/Camera3D/interaction".visible = false
	$"Neck/Camera3D/objectives".visible = false
	$Neck/Camera3D/inventory.visible = false
	$Neck/Camera3D/hitmarker.visible = false
	$"Neck/Camera3D/mobile controls".visible = false
	$"Neck/Camera3D/Death Screen".visible = true
	$"Neck/Camera3D/Death Screen/title".text = message
	GameManager.remove_objectives()
	GameManager.objectives_visible(false)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true

func _unhandled_input(event):
	if event is InputEventMouseButton and not GameManager.is_running_on_mobile():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event.is_action_pressed("pause"):
		pause_screen.pause()
	
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and not GameManager.is_running_on_mobile() and movement:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)
	elif GameManager.is_running_on_mobile() and movement:
		if event is InputEventScreenDrag:
			neck.rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)

func _process(_delta):
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))

func _physics_process(delta):
	if not movement: return
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("left", "right", "forwards", "backwards")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	gun_cam.global_transform = camera.global_transform
	fire()
	
	headbob_time += delta * velocity.length() * float(is_on_floor()) 
	camera.transform.origin = headbob(headbob_time)
	
	$Neck/Hand.rotation = $Neck/Camera3D.rotation
	
	if not footstep_landed and is_on_floor():
		footstep_audio.play()
	elif footstep_landed and not is_on_floor():
		footstep_audio.play()
	footstep_landed = is_on_floor()

func headbob(time):
	var headbob_position = Vector3.ZERO
	headbob_position.y = sin(time * headbob_frequency) * headbob_amplitude
	headbob_position.x = cos(time * headbob_frequency / 2) * headbob_amplitude
	
	var footstep_thershold = -headbob_amplitude + 0.002
	if headbob_position.y > footstep_thershold:
		footstep_can_play = true
	elif headbob_position.y < footstep_thershold and footstep_can_play:
		footstep_can_play = false
		footstep_audio.play()
	
	return headbob_position

func _ready():
	if GameManager.is_running_on_mobile():
		mobile_controls.visible = true
