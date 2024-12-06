extends Node3D

@export var id: int

var customer
var customerTop
var customerBottom
var topItem
var bottomItem

# meshes
var entering
var idle
var exiting

# sounds
var audio
var bell = preload("res://assets/sounds/Shop Door Bell.mp3")

@export var outLeftX = -28
@export var leftX = -15
@export var rightX = 11
@export var outRightX = 28

# 0: waiting
# 1: entering
# 2: proceeding
# 3: returning
# 4: exiting
var state = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	audio = $AudioStreamPlayer
	customer = $Customer
	customerTop = $Customer/"Top Half"
	customerBottom = $Customer/"Bottom Half"
	topItem = $TopItem
	bottomItem = $BottomItem
	entering = $Customer/EntranceWalkingMesh
	idle = $Customer/IdleMesh
	exiting = $Customer/ExitWalkingMesh
	topItem.set_holding(customerTop)
	bottomItem.set_holding(customerBottom)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state <= 0:
		idle.visible = true
		entering.visible = false
		exiting.visible = false
		if state == -1 and ready_to_swim():
			var twin = false
			for customer in get_tree().get_nodes_in_group("customer_id"):
				if customer.id == id * -1 and customer.state == -1:
					twin = true
					if customer.ready_to_swim():
						state = 2
						customer.state = 2
			if not twin:
				state = 2
		elif state == -2 and ready_to_leave():
			var twin = false
			for customer in get_tree().get_nodes_in_group("customer_id"):
				if customer.id == id * -1 and customer.state == -2:
					twin = true
					if customer.ready_to_leave():
						state = 4
						customer.state = 4
			if not twin:
				state = 4
	elif state == 1:
		enter(delta)
	elif state == 2:
		proceed(delta)
	elif state == 3:
		come_back(delta)
	elif state == 4:
		exit(delta)

func ready_to_swim():
	return topItem.is_in_group("hanging") and bottomItem.is_in_group("hanging")

func ready_to_leave():
	return topItem.is_in_group("worn") and bottomItem.is_in_group("worn")

func set_state(s):
	state = s

# Enter the scene from the left
func enter(delta):
	topItem.visible = false
	bottomItem.visible = false
	entering.visible = true
	idle.visible = false
	exiting.visible = false
	if id < 0 and global_position.x < leftX - 4:
		global_position.x += 4*delta
	elif id >= 0 and global_position.x < leftX:
		global_position.x += 4*delta
	else:
		global_position.z = 5.9
		topItem.visible = true
		bottomItem.visible = true
		state = -1

# Leave to the right
func proceed(delta):
	exiting.visible = true
	entering.visible = false
	idle.visible = false
	global_position.z = 0
	if id < 0 and global_position.x < outRightX + 4:
		global_position.x += 3*delta
	elif id >= 0 and global_position.x < outRightX:
		global_position.x += 3*delta
	else:
		state = 0

# Enter the scene from the right
func come_back(delta):
	customer.scale.x = -1
	exiting.visible = true
	idle.visible = false
	entering.visible = false
	if id < 0 and global_position.x > rightX + 4:
		global_position.x -= 3*delta
	elif id >= 0 and global_position.x > rightX:
		global_position.x -= 3*delta
	else:
		global_position.z = 5.9
		customer.scale.x = 1
		state = -2

# Leave to the left
func exit(delta):
	global_position.z = 0
	customer.scale.x = -1
	topItem.visible = false
	bottomItem.visible = false
	entering.visible = true
	idle.visible = false
	exiting.visible = false
	if id < 0 and global_position.x > outLeftX - 4:
		global_position.x -= 3*delta
	elif id >= 0 and global_position.x > outLeftX:
		global_position.x -= 3*delta
	else:
		customer.scale.x = 1
		state = 0
