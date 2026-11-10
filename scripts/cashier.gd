extends Clickzone

@export var ticket_generator: TicketGenerator
@export var counter: Counter

var ready_ticket: Ticket
var order_sandwiches: Array[Bread]

func _ready():
	super()
	animator.visible = false
	counter.placed.connect(_on_counter_placed)

func do_action():
	if ready_ticket:
		ready_ticket.complete(order_sandwiches)
		ticket_generator.cash_out(ready_ticket)
		ready_ticket = null
		order_sandwiches.clear()
		_on_counter_placed.call_deferred()

func _on_counter_placed() -> void:
	var available_counters = counter.counters.filter(func(c): return c.ingredient)
	for ticket_order in ticket_generator.tickets.filter(func(t): return t.sandwiches.size()):
		var count = 0
		for sandwich in ticket_order.sandwiches:
			for i in range(available_counters.size()):
				var counter_sandwich = available_counters[i].ingredient as Bread
				if sandwich.matches(counter_sandwich):
					count += 1
					order_sandwiches.append(available_counters.pop_at(i).ingredient)
					break
		if count == ticket_order.sandwiches.size():
			ready_ticket = ticket_order
			animator.visible = true
			return
	order_sandwiches.clear()
	animator.visible = false
