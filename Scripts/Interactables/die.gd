extends Area3D

func _on_body_entered(body):
	if body.has_method("die"):
		body.die("you killed yourself")
		GameManager.refresh_vars()
