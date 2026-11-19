class_name TicketGenerator
extends Node

const MAX_TICKETS := 4

@onready var ticket_bar = $CanvasLayer/Tickets/HBoxContainer

@export var ticket_prefab: PackedScene
@export var breads: Array[PackedScene]
@export var sauces: Array[PackedScene]
@export var eggs: Array[PackedScene]
@export var toppings: Array[PackedScene]

var tickets: Array[Ticket]

func _ready():
	SignalBus.sale_made.connect(_handle_sale)
	SignalBus.ticket_expired.connect(remove_ticket)

func take_order(customer: Customer):
	if tickets.size() > MAX_TICKETS:
		print("TOO MANY TICKETS")
		return
	var ticket := ticket_prefab.instantiate() as Ticket
	ticket.customer = customer
	ticket.sandwich = random_sandwich()
	ticket_bar.add_child(ticket)
	tickets.append(ticket)

# returns sandwich but doesn't add it to tree
func random_sandwich() -> Bread:
	var bread = breads.pick_random().instantiate() as Bread
	if randf() > .5:
		bread.ingredients.append(sauces.pick_random().instantiate())
	bread.ingredients.append(eggs.pick_random().instantiate())
	var topping_count = randi_range(0, toppings.size())
	var topping_copy = toppings
	for i in range(topping_count):
		var topping = topping_copy.pop_at(randi_range(0, topping_copy.size()-1)).instantiate()
		for ing in bread.ingredients:
			if ing.similar_ingredients.any(func(sim): return sim == topping.id):
				topping = ing.duplicate()
		bread.ingredients.append(topping)
	return bread

func _handle_sale(customer: Customer):
	for ticket in tickets:
		if ticket.customer == customer:
			remove_ticket(ticket)

func has_room() -> bool:
	return tickets.size() < MAX_TICKETS

func remove_ticket(ticket: Ticket):
	var i = tickets.find(ticket)
	tickets[i].queue_free.call_deferred()
	tickets.remove_at(i)
	print("deleting ticket")
