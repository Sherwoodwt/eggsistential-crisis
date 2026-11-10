class_name IngredientContainer
extends Dropzone

@onready var sprite: Sprite2D = $Sprite2D

@export var capacity: int
@export var amount: int
@export var ingredient_scene: PackedScene

func can_place(ing: Ingredient) -> bool:
	return false

func _ready():
	ingredient = ingredient_scene.instantiate() as Ingredient
	sprite.texture = ingredient.full_container_sprite
	
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
	var ratio = float(amount) / float(capacity)
	if ratio <= .5:
		sprite.texture = ingredient.half_container_sprite
	if amount == 1:
		sprite.texture = ingredient.last_container_sprite

func on_dropped():
	ingredient.visible = false
