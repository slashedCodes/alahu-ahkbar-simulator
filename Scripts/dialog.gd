extends Panel

@onready var options := $options
@onready var text_label := $RichTextLabel

func set_text(text: String):
	options.visible = false
	text_label.visible = true
	text_label.text = text

func clear_options():
	for child in options.get_node("HFlowContainer").get_children():
		child.queue_free()

func add_option(text: String, callback: Callable):
	var option = Button.new()
	option.text = text
	option.pressed.connect(callback)
	options.get_node("HFlowContainer").add_child(option)

func show_options():
	options.visible = true
	text_label.visible = false
