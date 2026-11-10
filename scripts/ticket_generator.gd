class_name TicketGenerator
extends Node

const MAX_TICKETS := 4

@onready var ticket_nodes: Array[Node2D] = [$Tickets/Ticket, $Tickets/Ticket2, $Tickets/Ticket3, $Tickets/Ticket4]

@export var ticket_prefab: PackedScene
@export var breads: Array[PackedScene]
@export var sauces: Array[PackedScene]
@export var eggs: Array[PackedScene]
@export var toppings: Array[PackedScene]

var cur := 0

var tickets: Array[Ticket]

func take_order(customer: Customer):
	if cur >= ticket_nodes.size():
		print("TOO MANY TICKETS")
		return
	var ticket = ticket_prefab.instantiate()
	var sandwich_count = randi_range(1, 4)
	for i in range(sandwich_count):
		var sandwich = random_sandwich()
		ticket.sandwiches.append(sandwich)
	ticket_nodes[cur].add_child(ticket)
	tickets.append(ticket)
	cur += 1
	set_current_visuals()
	
func set_current_visuals():
	cur = 0
	for ticket in tickets:
		ticket.reparent(ticket_nodes[cur])
		ticket.position = Vector2.ZERO
		cur += 1

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

func send_ticket(ticket: Ticket):
	var i = tickets.find(ticket)
	tickets.remove_at(i)
	print("deleting ticket")
	ticket.queue_free.call_deferred()
	set_current_visuals()
