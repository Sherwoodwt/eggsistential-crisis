class_name Order
extends Node2D

@onready var spaces: Array[Node2D] = [$TicketItem, $TicketItem2, $TicketItem3, $TicketItem4]

@export var sandwiches: Array[Bread]

var cur_spot: int

func _ready():
	if (sandwiches.size() > 0):
		new_ticket()
	else:
		visible = false

func new_ticket():
	visible = true
	cur_spot = 0
	for sandwich in sandwiches:
		add_child(sandwich)
		sandwich.visible = false
		for i in range(sandwich.ingredients.size()):
			var sprite = Sprite2D.new()
			sprite.texture = sandwich.ingredients[sandwich.ingredients.size() - 1 - i].icon_sprite
			sprite.scale = Vector2(.7, .7)
			sprite.position.y += i * 16
			spaces[cur_spot].add_child(sprite)
		cur_spot += 1
