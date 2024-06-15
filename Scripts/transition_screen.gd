extends CanvasLayer

signal transitioned

func fade_from_black():
	$AnimationPlayer.play("fade_from_black")

func fade_to_black():
	$AnimationPlayer.play("fade_to_black")

func _ready():
	fade_from_black()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		emit_signal("transitioned")
