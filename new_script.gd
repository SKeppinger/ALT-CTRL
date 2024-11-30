extends SerComm

var index = 0

func _ready():
	if open_serial():
		print("Processing serial communication via ", self.port)

func _exit_tree():
	close_serial()
