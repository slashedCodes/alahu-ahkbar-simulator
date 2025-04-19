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
@onready var animation_player = $AnimationPlayer
@onready var gun_audio_player = $"Gun Shoot"
@onready var ammo_label = $Neck/Camera3D/ammo
var reloading = false
var shooting = false
var ammo = 5

@onready var mobile_controls = camera.get_node("mobile controls")

@export_group("headbob")
@export var headbob_frequency := 2.0
@export var headbob_amplitude := 0.04
var headbob_time := 0.0

func fire():
	if reloading:
		animation_player.play("hand_reload")
		await animation_player.animation_finished
		ammo = 5
		ammo_label.text = str(ammo) + "/5 ammo"
		reloading = false
	
	if shooting:
		animation_player.play("hand_fire")
		shooting = false
	
	if hand.get_child_count() > 0 and hand.get_child(0).is_in_group("gun"):
		var action = "fire"
		if GameManager.is_running_on_mobile(): action = "mobile_fire"
		
		if Input.is_action_pressed("reload"): reloading = true

		if Input.is_action_just_pressed(action) and ammo > 0 and not reloading:
			if not animation_player.is_playing():
				ammo = ammo - 1
				ammo_label.text = str(ammo) + "/5 ammo"
				gun_audio_player.playing = false
				gun_audio_player.playing = true
				if raycast.is_colliding():
					var target = raycast.get_collider()
					if target.is_in_group("killable"):
						target.die(camera.global_basis.z)
			shooting = true

func die():
	$"Neck/Camera3D/interaction".visible = false
	$"Neck/Camera3D/Death Screen".visible = true
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
	gun_cam.global_transform = camera.global_transform
	fire()
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
	headbob_time += delta * velocity.length() * float(is_on_floor()) 
	camera.transform.origin = headbob(headbob_time)

func headbob(time):
	var headbob_position = Vector3.ZERO
	headbob_position.y = sin(time * headbob_frequency) * headbob_amplitude
	headbob_position.x = cos(time * headbob_frequency / 2) * headbob_amplitude
	return headbob_position

func _ready():
	if GameManager.is_running_on_mobile():
		mobile_controls.visible = true
