extends Node3D

@export var id: int

var customer
var topItem
var bottomItem

# Called when the node enters the scene tree for the first time.
func _ready():
	customer = $Customer
	topItem = $TopItem
	bottomItem = $BottomItem
	
