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
	#for i in range(ingredients.size()):
		# TODO: This would be worth more maybe
		#if ingredients[i].id != bread.ingredients[i].id:
		if bread.ingredients.find_custom(func(i): return i.id == ingredient.id) < 0:
			return false
	return true

func toggle_prepping(prepping: bool):
		for ing in ingredients:
			if ing != self:
				ing.position = ingredient_spot.position if prepping else Vector2.ZERO

func _on_placed():
	if self.ingredient is Bread:
		var bread = self.ingredient as Bread
		for ing in bread.ingredients:
			ing.visible = ing == bread
			ing.position = bread.ingredient_spot.position
