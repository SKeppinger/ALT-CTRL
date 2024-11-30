extends CharacterBody2D

const TIME_TO_DESTINATION = 10
const ACCEL_RATE = 2

var last_destination = self.position.x
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
	distance = last_destination - self.position.x
	if abs(speed) < abs(distance / TIME_TO_DESTINATION):
		speed += sign(distance) * ACCEL_RATE
	else:
		speed = distance / TIME_TO_DESTINATION
	if abs(speed) > abs(target_pos - self.position.x):
		self.position.x = target_pos
		speed = 0
	else:
		self.position.x += speed


# this code has errors for cases where only 1 "|" causes it to lock out.
#func process_buffer():
	#var beg = buffer.find("|")
	#var end = buffer.find("|", beg + 1)
	#var errChck = -1
	#var parseInt = -1
	#if beg != -1 and end != -1:
		#errChck = int(buffer.substr(beg + 1, 1))
		#parseInt = buffer.substr(beg + 2, end - beg - 2)
		#if parseInt.length() != errChck:
			#print("BAD LENGTH")
			#return
		#parseInt = int(parseInt)
	#else:
		#print(buffer)
		#print("BEG OR END IS BAD")
		#return
	#
	#print(errChck, " ", parseInt)
	
#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
