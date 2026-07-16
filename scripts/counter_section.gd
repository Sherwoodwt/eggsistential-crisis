class_name CounterSection
extends Dropzone

@onready var wrapping: Texture2D = preload("res://sprites/wrapped_sandwich.png") as Texture2D

func _ready():
	placed.connect(_on_placed)

func can_place(ingredient: Ingredient) -> bool:
	return ingredient is Bread

func _on_placed():
	self.ingredient.sprite.texture = wrapping
	for ing in (self.ingredient as Bread).ingredients:
		ing.visible = ing == self.ingredient
