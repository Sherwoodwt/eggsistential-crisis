class_name TicketItem
extends Control

@onready var image: TextureRect = $TextureRect
@onready var label: Label = $Label

@export var ingredient: Ingredient

var count: int

func _ready() -> void:
	count = 1
	image.texture = ingredient.icon_sprite
	label.text = ingredient.label

func add_count():
	count += 1
	label.text = "X%d %s" % [count, ingredient.label]
