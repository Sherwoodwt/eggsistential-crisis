class_name Ticket
extends Node2D

@onready var spaces: Array[Node2D] = [$TicketItem, $TicketItem2, $TicketItem3, $TicketItem4]

@export var sandwiches: Array[Bread]

var cur_spot: int

func _ready():
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

func complete(order_sandwiches: Array[Bread]):
	print("ticket complete")
	for sandwich in order_sandwiches:
		sandwich.queue_free.call_deferred()
	sandwiches.clear()
	visible = false
