class_name Trash
extends Dropzone

@export var capacity: int

var content: int

func _ready():
	placed.connect(_trash)

func _trash(ingredient: Ingredient):
	if content > capacity:
		return
	
	content += 1
	ingredient.queue_free.call_deferred()
