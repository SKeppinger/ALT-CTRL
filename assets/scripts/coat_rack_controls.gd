extends Node3D

const TIME_TO_DESTINATION = 10
const ACCEL_RATE = 2

var last_destination = self.rotation_degrees.y
var buffer = ""
var speed = 0
var target_pos = -1
var distance = 0

@onready var sercomm = %SerComm

func _ready():
	Engine.max_fps = 60

func _process(_delta):
	OS.delay_msec(18)
	if sercomm.waiting_input_bytes() > 0:
		buffer += sercomm.read_serial(sercomm.waiting_input_bytes())
		process_buffer()

func eqNegative(index):
	return index != -1

func findSign():
	var smallestVal
	var locArr = [buffer.find("+"), buffer.find("-"), buffer.find("N")]
	var filteredArr = locArr.filter(eqNegative) # filter out any -1 indices
	if filteredArr.size() == 0: # if all are -1 indices, should error out later
		return [-2, -1]
	elif filteredArr.size() == 1:
		smallestVal = filteredArr[0]
	else: # if there are two elements remaining, find smallest
		smallestVal = filteredArr.min()
	match locArr.find(smallestVal): # if only one element in array, reference that element
		0:
			return [smallestVal, 1]
		1:
			return [smallestVal, -1]
		2:
			return [smallestVal, 0]
	
func process_buffer():
	var res = findSign()
	var beg = res[0]
	var numSign = res[1]
	var errChck = -1
	var parseInt
	if beg != -1:
		errChck = int(buffer.substr(beg + 1, 1))
		parseInt = buffer.substr(beg + 2, errChck)
		if parseInt.length() != errChck:
			#print(buffer, " ", parseInt, " BAD LENGTH")
			return
		parseInt = int(parseInt) * numSign
		#lastPos = parseInt
		buffer = buffer.substr(beg + 2 + errChck)
	else:
		#print(buffer, " BEGINNING IS BAD")
		return
	
	if buffer.length() > 128: # 64
		#print("***buffer too large***")
		buffer = ""
	
	target_pos = parseInt * 2
	if target_pos != last_destination:
		last_destination = target_pos
	distance = last_destination - self.rotation_degrees.y
	if abs(speed) < abs(distance / TIME_TO_DESTINATION):
		speed += sign(distance) * ACCEL_RATE
	else:
		speed = distance / TIME_TO_DESTINATION
	if abs(speed) > abs(target_pos - self.rotation_degrees.y):
		var diff = target_pos - self.rotation_degrees.y
		self.rotation_degrees.y = target_pos
		# Also rotate hanging items
		for node in get_tree().get_nodes_in_group("hanging"):
			node.rotation_degrees.y += diff
		speed = 0
	else:
		self.rotation_degrees.y += speed
		# Also rotate hanging items
		for node in get_tree().get_nodes_in_group("hanging"):
			node.rotation_degrees.y += speed
