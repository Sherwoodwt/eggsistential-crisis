class_name Counter
extends Node

@onready var ingredient_list: Ticket = $Ticket

var counters: Array[CounterSection]
var reserved_sandwiches: Array[Bread]

func _ready():
	SignalBus.send_ticket.connect(_reserve_sandwiches)
	SignalBus.sale_made.connect(_reset_reservations)
	counters.assign(get_children().filter(func(c): return c is CounterSection))
	for counter in counters:
		counter.placed.connect(_update_counter)
		counter.ingredient_list = ingredient_list

func _update_counter():
	var sandwiches: Array[Bread] = []
	var s = counters \
		.filter(func(c: CounterSection): return c.ingredient != null) \
		.map(func(c: CounterSection): return c.ingredient as Bread)
	sandwiches.assign(s)
	SignalBus.counter_updated.emit(sandwiches)

func _reserve_sandwiches(ticket: Ticket):
	for counter in counters.filter(func(c): return c.ingredient != null):
		if not reserved_sandwiches.has(counter.ingredient) and ticket.sandwich.matches(counter.ingredient as Bread):
			reserved_sandwiches.append(counter.ingredient as Bread)
			counter.ingredient = null
			counter.disabled = true
	_update_counter()

func _reset_reservations(customer: Customer):
	for sandwich in reserved_sandwiches:
		sandwich.queue_free()
	reserved_sandwiches.clear()
	for counter in counters:
		counter.disabled = false
