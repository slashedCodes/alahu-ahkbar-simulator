extends Node3D

var rotate = false
var rotate_gun = false

func _ready():
	if GameManager.get_user_value("settings", "shaders_compiled") == true: GameManager.goto_scene("res://Scenes/Room.tscn", true)
	
	if get_tree().root.has_node("Main Menu"): queue_free()
	%shader.text = "shader: datamosh.glsl"
	if not GameManager.low_detail: %Camera3D.compositor.compositor_effects.get(0).enabled = true
	await get_tree().create_timer(1).timeout
	%shader.text = "shader: datamosh.glsl 50%"
	rotate = true
	await get_tree().create_timer(1).timeout
	rotate = false
	%Camera3D.rotation_degrees = Vector3.ZERO
	%shader.text = "shader: datamosh.glsl 100%"
	%Camera3D.compositor.compositor_effects.get(0).enabled = false
	await get_tree().create_timer(0.5).timeout
	%shader.text = "shader: weapon_shader.tres"
	%gun.show()
	await get_tree().create_timer(1).timeout
	%shader.text = "shader: weapon_shader.tres 50%"
	rotate_gun = true
	await get_tree().create_timer(1).timeout
	%shader.text = "shader: weapon_shader.tres 100%"
	await get_tree().create_timer(0.2).timeout
	%shader.text = "done"
	await get_tree().create_timer(0.2).timeout
	GameManager.set_user_value("settings", "shaders_compiled", true)
	GameManager.goto_scene("res://Scenes/Room.tscn", true)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		$CanvasLayer.visible = not $CanvasLayer.visible

func _physics_process(_delta):
	
	if rotate_gun:
		%gun.rotate_x(%gun.rotation_degrees.x + 5)
	
	if rotate:
		%Camera3D.rotate_x(%Camera3D.rotation_degrees.x + 5)
