extends Area3D

func _on_mouse_entered():
	if get_parent().is_in_group("interactable"):
		get_parent().add_to_group("targeted_item")

func _on_mouse_exited():
	get_parent().remove_from_group("targeted_item")
