extends Node3D

@onready var SIDE1 = $"Side 1"
@onready var SIDE2 = $"Side 2"
@onready var SIDE3 = $"Side 3"

const MAX_SIDE = 3

var current_side = SIDE1

# Rotate the coat rack
func rotate_rack(right):
	match current_side:
		SIDE1:
			if right:
				current_side = SIDE2
			else:
				current_side = SIDE3
		SIDE2:
			if right:
				current_side = SIDE3
			else:
				current_side = SIDE1
		SIDE3:
			if right:
				current_side = SIDE1
			else:
				current_side = SIDE2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
