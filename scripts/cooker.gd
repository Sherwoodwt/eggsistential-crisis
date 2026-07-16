class_name Cooker
extends Dropzone

@export var id: String

func can_place(ing: Ingredient) -> bool:
	if ing is Bread and (ing as Bread).ingredients.size() > 1:
		return false
	var index = ing.cook_methods.find_custom(func(m): return m.cooker == id)
	return !ingredient and index >= 0

func _ready():
	grabbed.connect(_on_grabbed)
	moved.connect(_on_moved)

func _on_grabbed():
	ingredient.stop_cookin()

func _on_moved():
	ingredient = null

func done_cookin(result: Ingredient):
	set_ingredient(result)

func set_ingredient(ingredient: Ingredient):
	self.ingredient = ingredient
	for connection in ingredient.done_cookin.get_connections():
		ingredient.done_cookin.disconnect(connection["callable"])
	ingredient.done_cookin.connect(done_cookin)
	ingredient.cook(self)
