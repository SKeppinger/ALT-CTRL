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

@export var leftX = -15
@export var rightX = 15

# 0: waiting
# 1: entering
# 2: proceeding
# 3: returning
# 4: exiting
var state = 0

# Called when the node enters the scene tree for the first time.
func _ready():
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
		if state == -1 and customer.ready_to_swim():
			state = 2
		elif state == -2 and customer.ready_to_leave():
			state = 4
	elif state == 1:
		enter(delta)
	elif state == 2:
		proceed(delta)
	elif state == 3:
		come_back(delta)
	elif state == 4:
		exit(delta)

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
		global_position.x += 3*delta
	elif id >= 0 and global_position.x < leftX:
		global_position.x += 3*delta
	else:
		global_position.z = 5.9
		topItem.visible = true
		bottomItem.visible = true
		state = -1

# Leave to the right
func proceed(delta):
	pass

# Enter the scene from the right
func come_back(delta):
	pass #when done, state = -2

# Leave to the left
func exit(delta):
	pass
