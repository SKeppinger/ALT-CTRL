extends Node3D

var coat_rack

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Get coat rack

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (is_in_group("hanging")):
		pass # Here is where we will move the item with the coat rack arm it is on
