extends Control

@onready var hand = get_parent().get_node("Hand")
var hand_index = null

func add_item(item):
	var instance = item.duplicate()
	self.add_child(instance)
	instance.visible = true

func remove_id(id):
	for item in get_children():
		if item.has_meta("id") and item.get_meta("id") == id:
			item.queue_free()
			
			if hand.get_child(0) and hand.get_child(0).has_meta("id") and hand.get_child(0).get_meta("id") == id:
				hand.get_child(0).queue_free()
			
			return

func remove_index(index):
	get_child(index).queue_free()

func remove_item(item):
	item.queue_free()

func select_item(index):
	# fix switching from one item to another
	
	if get_child(index):
		if hand_index == index:
			for child in hand.get_children():
				child.queue_free()
			
			hand_index = null
			return
		
		hand_index = index
		var item = get_child(index)
		var mesh = item.get_child(0).get_child(0).get_child(0)

		for child in hand.get_children():
			child.queue_free()
		
		hand.add_child(mesh.duplicate())
		mesh = hand.get_child(0) # update mesh var to the model in the hand
		
		if item.has_meta("id"):
			mesh.set_meta("id", item.get_meta("id"))
		
		if item.has_meta("scale"):
			mesh.scale = item.get_meta("scale")
		
		if item.has_meta("rotation"):
			mesh.rotation_degrees = item.get_meta("rotation")
		else:
			mesh.rotation_degrees = Vector3.ZERO
	else:
		hand_index = null
		for child in hand.get_children():
			child.queue_free()

func _input(event):
	if event.is_action_pressed("slot1"):
		select_item(0)
	elif event.is_action_pressed("slot2"):
		select_item(1)
	elif event.is_action_pressed("slot3"):
		select_item(2)
	elif event.is_action_pressed("slot4"):
		select_item(3)
	elif event.is_action_pressed("slot5"):
		select_item(4)
