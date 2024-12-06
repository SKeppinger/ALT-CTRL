extends Node3D

# These should all be the same length
@export var arriving_customers: Array[Node3D]
@export var enter_times: Array[float]
@export var leave_times: Array[float]

var leaving_customers = []

var enter_timer = 0.0
var leave_timer = 0.0
var entered = 0

var customer_waiting_left = false
var customer_waiting_right = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if len(enter_times) > 0:
		if len(leaving_customers) == 0 or leaving_customers[0].state != 1:
			enter_timer += delta
	if len(leaving_customers) > 0 and leaving_customers[0].state == 0:
		leave_timer += delta
	# ENTERING
	if len(enter_times) > 0 and enter_timer >= enter_times[0]:
		var wait = false
		for customer in get_tree().get_nodes_in_group("customer_id"):
			if customer.state == 1 or customer.state == -1:
				wait = true
		if not wait:
			arriving_customers[0].set_state(1)
			for customer in get_tree().get_nodes_in_group("customer_id"):
				if customer.id == arriving_customers[0].id * -1:
					customer.set_state(1)
			leaving_customers.append(arriving_customers[0])
			arriving_customers.remove_at(0)
			enter_times.remove_at(0)
			enter_timer = 0.0
		else:
			enter_timer -= delta
	# LEAVING
	if len(leave_times) > 0 and leave_timer >= leave_times[0]:
		var wait = false
		for customer in get_tree().get_nodes_in_group("customer_id"):
			if customer.state == 3 or customer.state == -2:
				wait = true
		if not wait:
			leaving_customers[0].set_state(3)
			for customer in get_tree().get_nodes_in_group("customer_id"):
				if customer.id == leaving_customers[0].id * -1:
					customer.set_state(3)
			leaving_customers.remove_at(0)
			leave_times.remove_at(0)
			leave_timer = 0.0
		else:
			leave_timer -= delta

func _on_interactable_area_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	area.get_parent().add_to_group("interactable")

func _on_interactable_area_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	area.get_parent().remove_from_group("interactable")
