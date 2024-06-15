extends CharacterBody3D
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var neck := $Neck
@onready var camera := $Neck/Camera3D
@onready var gun_cam := $Neck/Camera3D
@onready var pause_screen := $"Neck/Camera3D/Pause Screen"

@onready var raycast = $Neck/Camera3D/RayCast3D
@onready var hand = $Neck/Camera3D/Hand
@onready var animation_player = $AnimationPlayer
@onready var gun_audio_player = $"Gun Shoot"

func fire():
	if hand.get_child_count() > 0 and hand.get_child(0).is_in_group("gun"):
		if Input.is_action_pressed("fire"):
			if not animation_player.is_playing():
				gun_audio_player.playing = false
				gun_audio_player.playing = true
				if raycast.is_colliding():
					var target = raycast.get_collider()
					if target.is_in_group("killable"):
						target.die(camera.global_basis.z)
			animation_player.play("hand_fire")
		else:
			animation_player.stop()

func die():
	$"Neck/Camera3D/Death Screen".visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true

func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event.is_action_pressed("ui_cancel"):
		pause_screen.pause()
	
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))

func _physics_process(delta):
	gun_cam.global_transform = camera.global_transform
	fire()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forwards", "backwards")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
