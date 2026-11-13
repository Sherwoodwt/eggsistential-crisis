class_name Trash
extends Dropzone

@export var capacity: int

var content: int

func _ready():
	super()
	placed.connect(_trash)

func _trash():
	if content > capacity:
		return
	
	content += 1
	ingredient.queue_free.call_deferred()
