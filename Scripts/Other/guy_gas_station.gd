extends Node3D

@onready var chest = $skeleton/chest
@onready var stream_player = $AudioStreamPlayer3D

func die(direction):
	$npc.visible = false
	$skeleton.visible = true
	$skeleton.physical_bones_start_simulation()
	chest.apply_central_impulse(direction)
	stream_player.playing = false
	stream_player.playing = true
	$CollisionShape3D.queue_free()
	remove_from_group("killable")
	
	GameManager.remove_objectives()
	GameManager.add_objective("erase the security tapes from the cashiers computer")
