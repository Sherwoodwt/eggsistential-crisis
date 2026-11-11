class_name CustomerWindow
extends Clickzone

const LINE_MOVED_AMOUNT := 30.0

@onready var timer: Timer = $Timer
@onready var customer_spot: Node2D = $CustomerSpot
@onready var sprite: Sprite2D = $Sprite2D
@onready var highlight: AnimatedSprite2D = $Highlight
@onready var ui_linecount = $CanvasLayer/LineCount

@export var ticket_generator: TicketGenerator

var line: Array[Customer]

func _ready():
	super()
	timer.timeout.connect(_take_damage)
	SignalBus.new_customer.connect(_add_to_line)
	SignalBus.customer_expired.connect(_remove_customer)
	SignalBus.sale_made.connect(_remove_customer)

func do_action():
	if line.size() and ticket_generator.has_room():
		highlight.hide()
		ticket_generator.take_order(line[0])
		line.remove_at(0)
		timer.wait_time += LINE_MOVED_AMOUNT
		_refresh()

func _add_to_line(customer: Customer):
	line.append(customer)
	customer_spot.add_child(customer)
	_refresh()

func _refresh():
	ui_linecount.text = "IN LINE: %d" % line.size()
	if line.size() >= 1:
		sprite.texture = line[0].texture
		highlight.visible = ticket_generator.has_room()
	else:
		sprite.texture = null

func _remove_customer(customer: Customer):
	var i = line.find(customer)
	if i >= 0:
		line.remove_at(i)
		customer.queue_free()

func _take_damage():
	SignalBus.line_damage.emit()
	timer.start()
