extends Node2D

const MIN_TIME := 1.0
const MAX_TIME := 5.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var ui_linecount: Label = $LineCount
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

var approaching: Array[Ticket]
var in_line: Array[Ticket]

func _ready():
	SignalBus.send_ticket.connect(call_customer)
	SignalBus.sale_made.connect(customer_leave)

func call_customer(ticket: Ticket):
	add_child(GuiLogger.print("Order up!"))
	audio.play()
	approaching.append(ticket)
	get_tree().create_timer(randf_range(MIN_TIME, MAX_TIME)).timeout\
		.connect(func(): approach_counter(ticket))

func approach_counter(ticket: Ticket):
	approaching.remove_at(approaching.find(ticket))
	in_line.append(ticket)
	ui_linecount.text = "IN LINE: %d" % in_line.size()
	if in_line.size() == 1: # you are first in line
		sprite.texture = ticket.customer.texture
		SignalBus.ticket_ready.emit(in_line[0])

func customer_leave(ticket: Ticket):
	in_line.remove_at(in_line.find(ticket))
	ui_linecount.text = "IN LINE: %d" % in_line.size()
	if in_line.size():
		sprite.texture = in_line[0].customer.texture
		SignalBus.ticket_ready.emit.call_deferred(in_line[0])
	else:
		sprite.texture = null
