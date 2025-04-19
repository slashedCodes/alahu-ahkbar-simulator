extends StaticBody3D

@onready var cashier = $"../../guy"
@onready var player_neck = $"../../Player/Neck"
@onready var hand = player_neck.get_node("Hand")

func _physics_process(_delta):
	await get_tree().create_timer(0.1).timeout #so that i dont explode my pc
	
	if hand and hand.get_child_count() == 1:
		var mesh = hand.get_child(0)
		if mesh and mesh.has_meta("id") and mesh.get_meta("id") == "chips":
			set_meta("interactable", true)
			set_meta("text", "buy chips")
		else:
			set_meta("interactable", false)
			set_meta("text", "")
	else:
		set_meta("interactable", false)
		set_meta("text", "")

func interact(player_cam):
	var mesh = hand.get_child(0)
	if mesh and mesh.has_meta("id") and mesh.get_meta("id") == "chips":
		var inventory = player_cam.get_node("inventory")
		inventory.remove_id("chips")
		
		# chips
		$chips.visible = true
		set_meta("interactable", false)
		
		# objectives
		GameManager.remove_objectives()
		
		# play voice line
		$"line 1".playing = true
		
		await get_tree().create_timer(4.5).timeout
		cashier.add_to_group("killable")
		GameManager.add_objective("kill the cashier")
		
		await get_tree().create_timer(5.0).timeout
		if not cashier.dead:
			cashier.remove_from_group("killable")
			cashier.look_at_from_position(cashier.position, player_cam.position)
			
			cashier.get_node("gun").visible = true
			var id = cashier.get_node("npc").find_bone("mixamorig_RightArm_00")
			cashier.get_node("npc").set_bone_pose_rotation(id, Quaternion(-0.438, -0.62, -0.378, 0.53))
			
			$"line 2".playing = true
			await $"line 2".finished
			$boom.playing = true
			player_cam.get_parent().get_parent().die("you got shot")
