class_name Cooker
extends Dropzone

@export var id: String

func _ready():
	placed.connect(_on_placed)

func _on_placed():
	for connection in ingredient.done_cookin.get_connections():
		ingredient.done_cookin.disconnect(connection["callable"])
	ingredient.done_cookin.connect(done_cookin)
	ingredient.cook(self)

func done_cookin(result: Ingredient):
	result.cook(self)
