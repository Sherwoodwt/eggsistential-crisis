extends DropSpace

@export var capacity: int

var content: int

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("grab") and hover_ingredient != null and content < capacity:
		hover_ingredient.queue_free.call_deferred()
		content += 1
