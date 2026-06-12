extends Control

@export var egg_meat: PackedScene

func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		global_position = get_global_mouse_position()

func open(loc: Vector2):
	var instance = egg_meat.instantiate() as Control
	instance.position = loc
	add_sibling(instance)
	
#	for now destroy
	queue_free()
