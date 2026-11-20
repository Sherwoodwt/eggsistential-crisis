class_name Ingredient
extends Area2D

signal done_cookin(ingredient: Ingredient)

@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

@export var cook_methods: Array[CookMethod]
@export var id: String
@export var label: String
@export var is_edible: bool
@export var is_sauce: bool

@export var hover_sprite: Texture2D
@export var placed_sprite: Texture2D
@export var icon_sprite: Texture2D
@export var full_container_sprite: Texture2D
@export var half_container_sprite: Texture2D
@export var last_container_sprite: Texture2D
@export var empty_container_sprite: Texture2D

@export var similar_ingredients: Array[String]

var method: CookMethod

func _ready():
	timer.timeout.connect(finish_cookin)
	sprite.texture = placed_sprite

func cook(cooker: Dropzone):
	var i = cook_methods.find_custom(func(c): return c.cooker == cooker.id)
	if i < 0:
		return
	method = cook_methods[i]
	if timer.paused:
		timer.paused = false
	else:
		timer.wait_time = method.cook_time
		timer.start()

func stop_cookin():
	timer.paused = true

func finish_cookin():
	var instance = method.cooked_ingredient.instantiate() as Ingredient
	add_sibling(instance)
	if self is Bread and instance is Bread:
		(self as Bread).copy_ingredients(instance as Bread)
	queue_free.call_deferred()
	done_cookin.emit(instance)
