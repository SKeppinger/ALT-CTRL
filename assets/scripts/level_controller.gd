extends Node3D

# These should all be the same length
@export var arriving_customers: Array[Node3D]
@export var enter_times: Array[int]
@export var leave_times: Array[int]

var customer_waiting_left = false
var customer_waiting_right = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_interactable_area_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	area.get_parent().add_to_group("interactable")

func _on_interactable_area_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	area.get_parent().remove_from_group("interactable")
