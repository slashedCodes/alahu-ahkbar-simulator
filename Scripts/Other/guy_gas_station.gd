extends Node3D

@onready var chest = $skeleton/chest
@onready var stream_player = $AudioStreamPlayer3D

var dead = false

func die(direction):
	dead = true
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
	
	get_tree().current_scene.get_node("cop_timer").start()
	get_tree().current_scene.get_node("intense music").playing = true
	get_tree().current_scene.get_node("important interactables/buy chips/line 1").playing = false
