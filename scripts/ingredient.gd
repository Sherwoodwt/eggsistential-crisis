class_name Ingredient
extends Area2D


signal done_cookin(ingredient: Ingredient)

@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

@export var cook_methods: Array[CookMethod]
@export var id: String
@export var is_bread: bool
@export var is_edible: bool

var method: CookMethod

func _ready():
	timer.timeout.connect(finish_cookin)

func cook(cooker: Cooker):
	var i = cook_methods.find_custom(func(c): return c.cooker == cooker.id)
	if i < 0:
		return
	method = cook_methods[i]
	sprite.texture = method.cooking_sprite
	timer.wait_time = method.cook_time
	timer.start()

func finish_cookin():
	var instance = method.cooked_ingredient.instantiate() as Ingredient
	add_sibling(instance)
	queue_free.call_deferred()
	done_cookin.emit(instance)

func can_place(dropzone: Dropzone) -> bool:
	if dropzone is Cooker:
		var cooker = dropzone as Cooker
		var index = cook_methods.find_custom(func(m): return m.cooker == cooker.id)
		return index >= 0
	if dropzone is Trash:
		return true
	return false
