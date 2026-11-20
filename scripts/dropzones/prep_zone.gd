class_name PrepZone
extends Dropzone

func can_place(ing: Ingredient) -> bool:
	#if !ing.is_edible:
		#return false
	if !ingredient:
		return !ing.is_sauce
	return ingredient is Bread and ing is not Bread

func set_ingredient(ingredient: Ingredient):
	if self.ingredient is Bread:
		(self.ingredient as Bread).add_ingredient(ingredient)
	else:
		self.ingredient = ingredient

func _ready():
	super()
	placed.connect(_on_placed)
	moved.connect(_on_moved)

func _on_placed():
	if self.ingredient is Bread:
		for ing in (self.ingredient as Bread).ingredients:
			ing.visible = true

func _on_moved():
	self.ingredient = null
