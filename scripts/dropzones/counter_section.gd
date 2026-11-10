class_name CounterSection
extends Dropzone

@onready var wrapping: Texture2D = preload("res://sprites/wrapped_sandwich.png") as Texture2D

func _ready():
	placed.connect(_on_placed)
	moved.connect(_on_moved)

func can_place(ingredient: Ingredient) -> bool:
	return ingredient is Bread and self.ingredient == null

func _on_placed():
	var bread = self.ingredient as Bread
	bread.sprite.texture = wrapping
	for ing in bread.ingredients:
		ing.visible = ing == bread

func _on_moved():
	for ing in (self.ingredient as Bread).ingredients:
		ing.visible = true
	ingredient = null
