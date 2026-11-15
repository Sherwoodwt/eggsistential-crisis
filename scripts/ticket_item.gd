class_name TicketItem
extends Control

@onready var image: TextureRect = $TextureRect
@onready var label: Label = $Label

@export var ingredient: Ingredient

func _ready() -> void:
	image.texture = ingredient.icon_sprite
	label.text = ingredient.label
