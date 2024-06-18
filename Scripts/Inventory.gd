extends Control

@onready var hand = get_parent().get_node("Hand")
var hand_index = 0
var hand_selected = false
var item_count = 0

func add_item(item):
	item_count = item_count + 1
	var instance = item.duplicate()
	var style = StyleBoxFlat.new()
	
	# set style
	style.bg_color = Color("#313131")
	instance.add_theme_stylebox_override('panel', style)
	
	# mobile button code
	if GameManager.is_running_on_mobile():
		var b = Button.new()
		
		b.set_anchors_preset(Control.PRESET_FULL_RECT)
		b.self_modulate = Color(1, 1, 1, 0)
		var script = load("res://Scripts/Misc/mobile_hotbar_button.gd")
		b.set_script(script)
		instance.add_child(b)
	
	self.add_child(instance)
	instance.visible = true

func remove_id(id):
	for item in get_children():
		if item.has_meta("id") and item.get_meta("id") == id:
			item.queue_free()
			
			if hand.get_child(0) and hand.get_child(0).has_meta("id") and hand.get_child(0).get_meta("id") == id:
				item_count = item_count - 1
				hand.get_child(0).queue_free()
			
			return

func remove_index(index):
	get_child(index).queue_free()
	item_count = item_count - 1

func remove_item(item):
	item.queue_free()
	item_count = item_count - 1

func select_item(index):
	if get_child(index):
		if hand_selected and hand_index == index:
			for child in hand.get_children():
				child.queue_free()
			
			for item_panel in get_children():
				unhighlight_panel(item_panel)
			
			hand_selected = false
			return
		
		hand_index = index # set the selected index to the current one
		var item = get_child(index) # get the index
		
		# unhighlight everything
		for item_panel in get_children():
			unhighlight_panel(item_panel)
		
		# highlight the current item
		highlight_panel(item)
		
		var mesh = item.get_child(0).get_child(0).get_child(0) # get the mesh
		
		# Clear everything in the hand
		for child in hand.get_children():
			child.queue_free()
		
		mesh = mesh.duplicate() # duplicate the mesh
		
		if item.has_meta("id"):
			mesh.set_meta("id", item.get_meta("id"))
		
		if item.has_meta("scale"):
			mesh.scale = item.get_meta("scale")
		
		if item.has_meta("rotation"):
			mesh.rotation_degrees = item.get_meta("rotation")
		else:
			mesh.rotation_degrees = Vector3.ZERO
		
		hand.add_child(mesh)
		hand_selected = true
	else:
		hand_selected = false
		
		for item_panel in get_children():
			unhighlight_panel(item_panel)
		
		for child in hand.get_children():
			child.queue_free()
		return

func highlight_panel(panel):
	var style = panel.get_theme_stylebox('panel')
	style.bg_color = Color("#525252")

func unhighlight_panel(panel):
	var style = panel.get_theme_stylebox('panel')
	style.bg_color = Color("#313131")

func _input(event):
	if event.is_action_pressed("hotbar_left"):
		select_item((hand_index - 1) % item_count)
	elif event.is_action_pressed("hotbar_right"):
		select_item((hand_index + 1) % item_count)
	
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
