class_name Bread
extends Ingredient

@onready var ingredient_spot: Node2D = $ingredient_spot

const MAX_DIFFERENCE_TO_MATCH := 3

var ingredients: Array[Ingredient]
var closed: bool

func _ready():
	super()
	ingredients.push_front(self)

# returns count representing differences between breads ingredients
func compare_differences(bread: Bread) -> int:
	var differences = 0
	var bread_ingredients_copy := bread.ingredients.duplicate(true)
	for ingredient in ingredients:
		var matches = 0
		for ing: Ingredient in bread_ingredients_copy:
			if ing.id == ingredient.id or ing.similar_ingredients.find(ingredient.id) >= 0:
				matches += 1 # similar ingredient == 1 match
				if ing.id == ingredient.id:
					matches += 1 # identical ingredient == another match
				bread_ingredients_copy.remove_at(bread_ingredients_copy.find(ing))
			if not ing.is_edible:
				matches -= 10 # inedible food is bad
		differences += 2 - matches # matches of 2 == 0 diffs
	for ingredient in bread_ingredients_copy:
		differences += 2 # extra unwanted ingredient same penalty as missing ingredient
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
