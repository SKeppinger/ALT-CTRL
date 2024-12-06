extends Node3D

@export var id: int

var customerTop
var customerBottom
var topItem
var bottomItem

# Called when the node enters the scene tree for the first time.
func _ready():
	customerTop = $Customer/"Top Half"
	customerBottom = $Customer/"Bottom Half"
	topItem = $TopItem
	bottomItem = $BottomItem
	topItem.set_holding(customerTop)
	bottomItem.set_holding(customerBottom)
