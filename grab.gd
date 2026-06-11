extends Panel

@export var item_scene: PackedScene

func _get_drag_data(at_position: Vector2) -> Variant:
	var instance = item_scene.instantiate()
	get_tree().root.add_child(instance)
	return instance

#func grab():
	#var instance = item_scene.instantiate()
	#get_tree().root.add_child(instance)
