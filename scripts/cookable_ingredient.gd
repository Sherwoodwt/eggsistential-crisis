class_name CookableIngredient
extends Ingredient

signal done_cookin(ingredient: Ingredient)

@export var cook_methods: Array[CookMethod]

func _ready():
	pass

func cook(cooker: Cooker):
	var index = cook_methods.find_custom(func(m): return m.cooker == cooker.id)
	if index < 0:
		return
	
	var method = cook_methods[index]
	sprite.texture = method.cooking_sprite
	timer.wait_time = method.cook_time
	timer.timeout.connect(done_cooking.bind(method))
	timer.start()

func done_cooking(method: CookMethod):
	var instance = method.cooked_ingredient.instantiate() as Ingredient
	add_sibling(instance)
	queue_free.call_deferred()
	done_cookin.emit(instance)
