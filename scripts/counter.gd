class_name Counter
extends Node

var counters: Array[CounterSection]
var reserved_sandwiches: Array[Bread]

func _ready():
	SignalBus.ticket_created.connect(func(t): _update_counter())
	SignalBus.send_ticket.connect(_reserve_sandwiches)
	SignalBus.sale_made.connect(_unreserve_sandwiches)
	counters.assign(get_children().filter(func(c): return c is CounterSection))
	for counter in counters:
		counter.placed.connect(_update_counter)

func _update_counter():
	var sandwiches: Array[Bread] = []
	var s = counters \
		.filter(func(c: CounterSection): return c.ingredient != null) \
		.map(func(c: CounterSection): return c.ingredient as Bread)
	sandwiches.assign(s)
	SignalBus.counter_updated.emit(sandwiches)

func _reserve_sandwiches(ticket: Ticket):
	for counter in counters.filter(func(c): return c.ingredient != null):
		if not reserved_sandwiches.has(counter.ingredient) and ticket.sandwich_match == counter.ingredient:
			reserved_sandwiches.append(counter.ingredient as Bread)
			counter.ingredient = null
			counter.disabled = true
	_update_counter()

func _unreserve_sandwiches(ticket: Ticket):
	for sandwich in reserved_sandwiches:
		if sandwich == ticket.sandwich_match:
			var i = counters.find_custom(func(c): return c.ingredient == sandwich)
			var counter = counters[i] as CounterSection
			counter.disabled = false
			reserved_sandwiches.remove_at(reserved_sandwiches.find(sandwich))
			sandwich.queue_free()
	_update_counter()
