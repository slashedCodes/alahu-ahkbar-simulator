extends Node3D

@onready var animation_player = $AnimationPlayer
@onready var gun_audio_player = $"Gun Shoot"
@onready var ammo_label = $ammo
@onready var bullethole = preload("res://Scenes/bullethole.tscn")
var reloading = false
var shooting = false
var max_ammo = 5
var ammo = 5

func fire(raycast, player):
	var hand = player.get_node("Neck/Hand")
	var camera = player.get_node("Neck/Camera3D")
	
	if reloading:
		animation_player.play("hand_reload")
		await animation_player.animation_finished
		ammo = 5
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
					
					if not GameManager.low_detail:
						var hole = bullethole.instantiate()
						target.add_child(hole)
						hole.global_position = raycast.get_collision_point()
						hole.look_at(hole.global_transform.origin + raycast.get_collision_normal(), Vector3.UP)
						if raycast.get_collision_normal() != Vector3.UP and raycast.get_collision_normal() != Vector3.DOWN:
							hole.rotate_object_local(Vector3(1, 0, 0), 90)
						
			shooting = true
