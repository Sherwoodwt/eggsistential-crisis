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
	SignalBus.sale_made.connect(remove_ticket)
	SignalBus.customer_expired.connect(remove_ticket)

func take_order(customer: Customer):
	if tickets.size() > MAX_TICKETS:
		print("TOO MANY TICKETS")
		return
	var ticket := ticket_prefab.instantiate() as Ticket
	ticket.customer = customer
	var sandwich_count = randi_range(1, 4)
	for i in range(sandwich_count):
		var sandwich = random_sandwich()
		ticket.sandwiches.append(sandwich)
	ticket_bar.add_child(ticket)
	tickets.append(ticket)

func random_sandwich() -> Bread:
	var bread = breads.pick_random().instantiate() as Bread
	if randf() > .5:
		bread.ingredients.append(sauces.pick_random().instantiate())
	bread.ingredients.append(eggs.pick_random().instantiate())
	var topping_count = randi_range(0, toppings.size())
	var topping_copy = toppings
	for i in range(topping_count):
		var topping = topping_copy.pop_at(randi_range(0, topping_copy.size()-1)).instantiate()
		bread.ingredients.append(topping)
	return bread

func has_room() -> bool:
	return tickets.size() < MAX_TICKETS

func remove_ticket(customer: Customer):
	var i = tickets.find_custom(func(t): return t.customer == customer)
	tickets[i].queue_free.call_deferred()
	tickets.remove_at(i)
	print("deleting ticket")
