extends Node3D

@export var MOUSE_DEPTH = 6.0

var held_item = null
var coat_rack = null

# Called when the node enters the scene tree for the first time.
func _ready():
	coat_rack = get_tree().get_first_node_in_group("coat_rack")

# Get the mouse position in 3D to drag objects
func get_mouse_position():
	var currentCamera = get_viewport().get_camera_3d()
	var params = PhysicsRayQueryParameters3D.new()
	params.from = currentCamera.project_ray_origin(get_viewport().get_mouse_position())
	params.to = params.from + currentCamera.project_local_ray_normal(get_viewport().get_mouse_position()) * 1000
	
	var worldspace = get_world_3d().direct_space_state
	var result = worldspace.intersect_ray(params)
	
	if result != {}:
		result.position.z = MOUSE_DEPTH
		return result.position
	else:
		return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Read player input for rotating the coat rack (temporarily using keyboard input)
	# In the future, a number will be read in and the coat rack's rotation will be set to that number
	if Input.is_action_pressed("rotate_right"):
		coat_rack.rotate_y(0.03)
		# Also rotate hanging items
		for node in get_tree().get_nodes_in_group("hanging"):
			var vector_between = node.global_position - coat_rack.global_position
			vector_between = vector_between.rotated(Vector3(0, 1, 0), 0.03)
			node.global_position = vector_between
			node.rotate_y(0.03)
	elif Input.is_action_pressed("rotate_left"):
		coat_rack.rotate_y(-0.03)
		# Also rotate hanging items
		for node in get_tree().get_nodes_in_group("hanging"):
			var vector_between = node.global_position - coat_rack.global_position
			vector_between = vector_between.rotated(Vector3(0, 1, 0), -0.03)
			node.global_position = vector_between
			node.rotate_y(-0.03)
	# Read player input for dragging items
	if held_item and Input.is_action_pressed("left_click"):
		# Continue dragging the held item
		if get_mouse_position():
			if held_item.is_in_group("bottom"):
				held_item.global_position = get_mouse_position()
				held_item.global_position.y += 2.5
			else:
				held_item.global_position = get_mouse_position()
	elif !held_item and Input.is_action_just_pressed("left_click"):
		if (get_tree().get_first_node_in_group("targeted_item")):
			held_item = get_tree().get_first_node_in_group("targeted_item") # Pick up the item
			held_item.remove_from_group("hanging")
			held_item.remove_from_group("worn")
			if held_item.get_holding():
				held_item.clear_holding()
			held_item.rotation = Vector3(0, 0, 0)
	elif held_item and Input.is_action_just_released("left_click"):
		held_item.dropped.emit()
		held_item = null # Stop holding the item
