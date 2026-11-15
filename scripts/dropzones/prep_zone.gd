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
	grabbed.connect(_on_grabbed)
	moved.connect(_on_moved)
	placed.connect(_on_placed)
	dropped.connect(_on_dropped)

func _on_grabbed():
	if self.ingredient is Bread:
		(self.ingredient as Bread).toggle_prepping(false)

func _on_moved():
	self.ingredient = null

func _on_placed():
	if self.ingredient is Bread:
		(self.ingredient as Bread).toggle_prepping(true)

func _on_dropped():
	if self.ingredient is Bread:
		(self.ingredient as Bread).toggle_prepping(true)
	
