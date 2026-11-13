extends Node2D

const MIN_TIME := 1.0
const MAX_TIME := 5.0

@onready var timer: Timer = $Timer
@onready var sprite: Sprite2D = $Sprite2D

var current_ticket: Ticket

func _ready():
	SignalBus.send_ticket.connect(call_customer)
	timer.timeout.connect(approach_counter)
	SignalBus.sale_made.connect(customer_leave)

func call_customer(ticket: Ticket):
	current_ticket = ticket
	timer.wait_time = randf_range(MIN_TIME, MAX_TIME)
	timer.start()

func approach_counter():
	timer.stop()
	sprite.texture = current_ticket.customer.texture
	SignalBus.customer_ready_to_checkout.emit(current_ticket.customer)

func customer_leave(customer: Customer):
	sprite.texture = null
