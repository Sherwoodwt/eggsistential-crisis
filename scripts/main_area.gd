extends Node

@onready var ui_served: Label = $CanvasLayer/Served
@onready var ui_money: Label = $CanvasLayer/Money
@onready var ui_score_debug: Label = $CanvasLayer/Score_DEBUG
@onready var ui_health: TextureProgressBar = $CanvasLayer/Health

var sale_count := 0

func _ready():
	SignalBus.sale_made.connect(_refresh)
	SignalBus.customer_expired.connect(_take_damage)
	SignalBus.ticket_expired.connect(func(t): _take_damage())
	$FailButton.pressed.connect(func(): SignalBus.lose.emit())

func _refresh(ticket: Ticket):
	sale_count += 1
	ui_served.text = "SERVED: %d" % sale_count
	ui_money.text = "$%d" % ticket.get_price()

func _take_damage():
	ui_health.value -= 1
	if ui_health.value <= 0:
		SignalBus.lose.emit()
