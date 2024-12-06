extends Node3D

@export var ID: int

signal dropped

var coat_rack
var area
var hovering = null
var holding = null

func get_holding():
	return holding

func clear_holding():
	holding.remove_from_group("holding")
	holding = null

func set_holding(holder):
	hovering = holder
	dropped.emit()

func _ready():
	coat_rack = get_tree().get_first_node_in_group("coat_rack")
	area = $ItemArea

func _process(_delta):
	if holding and is_in_group("worn"):
		self.position = Vector3(0, 0, 0.1)
	elif holding and is_in_group("hanging"):
		self.global_position = holding.global_position
	if is_in_group("hanging"):
		self.global_position.y += -1.0 * area.position.y

func _on_dropped():
	if hovering and !hovering.is_in_group("holding"):
		print("dropped onto receiever")
		global_position = hovering.global_position
		if hovering.get_parent().get_parent().get_parent() and hovering.get_parent().get_parent().get_parent().is_in_group("coat_rack"): # This is ugly but it works
			var side_difference = 0.0
			match hovering.get_parent().get_parent().get_name(): # So is this :(
				"Side 1":
					side_difference = 0.0
				"Side 2":
					side_difference = 120.0
				"Side 3":
					side_difference = -120.0
			rotation = Vector3(0, deg_to_rad(side_difference), 0) + coat_rack.rotation
			add_to_group("hanging")
		else:
			add_to_group("worn")
			print("worn")
		hovering.get_parent().add_to_group("holding")
		holding = hovering.get_parent()

func _on_drop_area_area_entered(area):
	if area.get_parent().is_in_group("item_receiver") and not area.get_parent().is_in_group("holding"):
		if (area.get_parent().is_in_group("top") and is_in_group("top")) or (area.get_parent().is_in_group("bottom") and is_in_group("bottom")):
			print(area.get_parent().get_parent())
			print(get_parent())
			if area.get_parent().is_in_group("coat_rack_arm") or area.get_parent().get_parent().get_parent() == get_parent():
				print("hover")
				hovering = area
				area.add_to_group("hovering")

func _on_drop_area_area_exited(area):
	if area.is_in_group("hovering"):
		print("not hover")
		area.remove_from_group("hovering")
