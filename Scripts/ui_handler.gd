extends Camera3D

@onready var hand := $Hand
@onready var objectives := $objectives
@onready var interaction := $interaction
@onready var inventory := $inventory
@onready var ammo := $ammo
@onready var root := get_tree().current_scene

func get_ray():
	var space = get_world_3d().direct_space_state
	var camera = get_tree().root.get_camera_3d()
	var rayOrigin = camera.project_ray_origin(Vector2(225, 200)) # middle of the screen
	var rayEnd = rayOrigin + camera.project_ray_normal(Vector2(225, 200)) * 2.5 # middle of the screen
	var rayArray = space.intersect_ray(PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd))
	return rayArray

func _ready():
	if root and root.has_node("questions"):
		for question in root.get_node("questions").get_children():
			await get_tree().create_timer(question.get_meta("delay")).timeout # wait the delay the question has set
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			question.visible = true
			get_tree().paused = true

func _process(delta):
	if hand.get_child_count() > 0 and hand.get_child(0).is_in_group("gun"):
		ammo.visible = true
	else:
		ammo.visible = false
	
	var intersected = get_ray()
	if intersected.has("collider") and intersected["collider"].has_meta("text"):
		# Set interaction text
		if intersected["collider"].has_meta("interactable") and intersected["collider"].get_meta("interactable"):
			interaction.text = "E - " + intersected["collider"].get_meta("text")
		else:
			interaction.text = intersected["collider"].get_meta("text")
		
		# Interaction code
		if intersected["collider"].has_meta("interactable") and intersected["collider"].get_meta("interactable") and intersected["collider"].has_method("interact") and Input.is_action_just_pressed("interact"):
			intersected["collider"].interact(get_node(".")) # pass player into the function
		
		# Add to inventory
		if intersected["collider"].has_node("Item") and intersected["collider"].get_meta("interactable") and intersected["collider"].get_meta("interactable") and Input.is_action_just_pressed("interact"):
			inventory.add_item(intersected["collider"].get_node("Item"))
			intersected["collider"].get_node(intersected["collider"].get_meta("model")).queue_free()
	else:
		interaction.text = ""
