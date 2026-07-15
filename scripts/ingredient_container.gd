class_name IngredientContainer
extends Dropzone

@onready var contents: Sprite2D = $Contents

@export var capacity: int
@export var amount: int
@export var ingredient_scene: PackedScene

func _ready():
	# set icon
	ingredient = ingredient_scene.instantiate() as Ingredient
	var children = ingredient.get_children()
	var i = children.find_custom(func(c): return c is Sprite2D)
	if i >= 0:
		var sprite = children[i] as Sprite2D
		contents.texture = sprite.texture
	
	ingredient.visible = false
	grabbed.connect(create_ingredient)
	moved.connect(on_moved)
	dropped.connect(on_dropped)
	add_child(ingredient)

func create_ingredient():
	ingredient.visible = true

func on_moved():
	amount -= 1
	if amount >= 0:
		ingredient = ingredient_scene.instantiate()
		ingredient.visible = false
		add_child(ingredient)

func on_dropped():
	ingredient.visible = false
