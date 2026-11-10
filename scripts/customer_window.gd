class_name CustomerWindow
extends Clickzone

@onready var sprite: Sprite2D = $Sprite2D
@onready var highlight: AnimatedSprite2D = $Highlight
@onready var ui_linecount = $CanvasLayer/LineCount

@export var ticket_generator: TicketGenerator

var line: Array[Customer]

func _ready():
	super()
	SignalBus.new_customer.connect(_add_to_line)

func do_action():
	if line.size() and ticket_generator.has_room():
		highlight.hide()
		ticket_generator.take_order(line[0])
		line.remove_at(0)
		_refresh()

func _add_to_line(customer: Customer):
	line.append(customer)
	_refresh()

func _refresh():
	ui_linecount.text = "IN LINE: %d" % line.size()
	if line.size() == 1:
		sprite.texture = line[0].sprite
		highlight.show()
	else:
		sprite.texture = null
