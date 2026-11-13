class_name CounterSection
extends Dropzone

@onready var wrapping: Texture2D = preload("res://sprites/wrapped_sandwich.png") as Texture2D

var ingredient_list: Ticket

func _ready():
	super()
	placed.connect(_on_placed)
	moved.connect(_on_moved)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

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

func _on_mouse_entered():
	if ingredient:
		ingredient_list.show()
		ingredient_list.set_sandwich(ingredient)

func _on_mouse_exited():
	ingredient_list.hide()
	ingredient_list.clear_sandwich()
