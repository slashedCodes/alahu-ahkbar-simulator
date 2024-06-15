extends Area3D

func _on_body_entered(body):
	print(body)
	if body.has_method("die"):
		body.die()
		GameManager.refresh_vars()
