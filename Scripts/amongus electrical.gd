extends Node2D

var left_wires = []
var right_wires = []

func assign_wire_colors():
	var rng = RandomNumberGenerator.new()
	
	for i in range(0, 3):
		left_wires.append(rng.randi_range(1, 4))
		right_wires.append(rng.randi_range(1, 4))

