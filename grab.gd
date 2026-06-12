extends Panel

@export var item_scene: PackedScene

func _get_drag_data(at_position: Vector2) -> Variant:
	var instance = item_scene.instantiate()
	add_sibling(instance)
	return instance
