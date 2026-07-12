class_name Cooker
extends DropSpace

@export var id: String

func _on_drop():
	super()
	ingredient.cook(self)
	ingredient.done_cookin.connect(done_cookin)

func done_cookin(result: Ingredient):
	result.cook(self)
	ingredient = result
