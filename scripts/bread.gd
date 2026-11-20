class_name Bread
extends Ingredient

@onready var ingredient_spot: Node2D = $ingredient_spot

const MAX_DIFFERENCE_TO_MATCH := 3

var ingredients: Array[Ingredient]
var closed: bool

func _ready():
	super()
	ingredients.push_front(self)

func matches(bread: Bread) -> bool:
	var diff := compare_differences(bread)
	return diff <= MAX_DIFFERENCE_TO_MATCH

# returns count representing differences between breads ingredients
func compare_differences(bread: Bread) -> int:
	var differences = 0
	var bread_ingredients_copy := bread.ingredients.duplicate(true)
	for ingredient in ingredients:
		var score = 0
		for ing in bread_ingredients_copy:
			if ing.id == ingredient.id or ing.similar_ingredients.find(ingredient.id) >= 0:
				score += 1 # similar ingredient == 1 difference
				if ing.id == ingredient.id:
					score += 1 # different ingredient == 2 difference
				bread_ingredients_copy.remove_at(bread_ingredients_copy.find(ing))
		differences += 2 - score
	for ingredient in bread_ingredients_copy:
		differences += 1 # added difference for each extra unwanted ingredient
	return differences

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
