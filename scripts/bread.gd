class_name Bread
extends Ingredient

@onready var ingredient_spot: Node2D = $ingredient_spot

var ingredients: Array[Ingredient]
var closed: bool

func _ready():
	super()
	ingredients.push_front(self)

func matches(bread: Bread) -> bool:
	if bread.ingredients.size() != ingredients.size():
		return false
	for ingredient in ingredients:
		if not bread.ingredients.any(func(i): return i.id == ingredient.id):
			return false
	return true

func toggle_prepping(prepping: bool):
	for ing in ingredients:
		if ing != self:
			ing.position = ingredient_spot.position if prepping else Vector2.ZERO

func add_ingredient(ingredient: Ingredient):
	ingredients.push_back(ingredient)
	ingredient.reparent(ingredient_spot)
	var random_variance := Vector2(randf_range(-.1, .1), randf_range(-.1, .1))
	ingredient.global_position = ingredient_spot.global_position + random_variance
	ingredient.sprite.z_index = 1

# copies ingredients from self to to
func copy_ingredients(to: Bread) -> void:
	to.ingredients = self.ingredients
	to.ingredients[0] = to # reset this back
	for child in self.ingredient_spot.get_children():
		child.reparent(to.ingredient_spot)

func _on_placed():
	if self.ingredient is Bread:
		var bread = self.ingredient as Bread
		for ing in bread.ingredients:
			ing.visible = ing == bread
			ing.position = bread.ingredient_spot.position
