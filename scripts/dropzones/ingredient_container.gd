class_name IngredientContainer
extends Dropzone

@onready var sprite: Sprite2D = $Sprite2D

@export var capacity: int
@export var amount: int
@export var ingredient_scene: PackedScene

func can_place(ing: Ingredient) -> bool:
	return false

func _ready():
	super()
	ingredient = ingredient_scene.instantiate() as Ingredient
	sprite.texture = ingredient.full_container_sprite
	
	ingredient.visible = false
	grabbed.connect(pickup_ingredient)
	moved.connect(on_moved)
	dropped.connect(on_dropped)
	add_child(ingredient)

func pickup_ingredient():
	ingredient.visible = true
	highlight.visible = true

func on_moved():
	amount -= 1
	if amount >= 0:
		ingredient = ingredient_scene.instantiate() as Ingredient
		add_child(ingredient)
		ingredient.visible = false
		highlight.visible = false
	var ratio = float(amount) / float(capacity)
	if ratio <= .5:
		sprite.texture = ingredient.half_container_sprite
	if amount == 1:
		sprite.texture = ingredient.last_container_sprite
	if amount == 0:
		sprite.texture = ingredient.empty_container_sprite

func on_dropped():
	ingredient.visible = false
	highlight.visible = false
