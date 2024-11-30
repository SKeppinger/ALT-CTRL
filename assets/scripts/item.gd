extends Node3D

signal dropped

var coat_rack
var hovering = null
var holding = null

func get_holding():
	return holding

func clear_holding():
	holding.remove_from_group("holding")
	holding = null

func _ready():
	coat_rack = get_tree().get_first_node_in_group("coat_rack")

func _process(_delta):
	if holding and is_in_group("worn"):
		self.global_position = holding.get_parent().global_position
		self.global_position.z += 0.1
	elif holding and is_in_group("hanging"):
		self.global_position = holding.global_position
	if holding and is_in_group("bottom"):
		self.global_position.y += 2.5

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
		hovering.add_to_group("holding")
		holding = hovering

func _on_drop_area_area_entered(area):
	if area.get_parent().is_in_group("item_receiver"):
		if (area.get_parent().is_in_group("top") and is_in_group("top")) or (area.get_parent().is_in_group("bottom") and is_in_group("bottom")):
			print("hover")
			hovering = area
			area.add_to_group("hovering")

func _on_drop_area_area_exited(area):
	if area.is_in_group("hovering"):
		print("not hover")
		hovering = null
		area.remove_from_group("hovering")
