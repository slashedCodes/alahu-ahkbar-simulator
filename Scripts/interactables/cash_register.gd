extends StaticBody3D

@onready var cashier = $"../guy"

func interact(player_cam):
	var hand = player_cam.get_node("Hand")
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
		
		# no voice line
		
		await get_tree().create_timer(5.0).timeout
		cashier.add_to_group("killable")
		GameManager.add_objective("kill the cashier")
