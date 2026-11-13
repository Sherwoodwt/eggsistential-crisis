extends Node

@onready var ui_score: Label = $CanvasLayer/Score
@onready var ui_health: TextureProgressBar = $CanvasLayer/Health

var sale_count := 0

func _ready():
	SignalBus.sale_made.connect(func(c): _refresh())
	SignalBus.customer_expired.connect(_take_damage)
	SignalBus.line_damage.connect(_take_damage)

func _refresh():
	sale_count += 1
	ui_score.text = "SERVED: %d" % sale_count

func _take_damage():
	ui_health.value -= 1
	if ui_health.value <= 0:
		SignalBus.lose.emit()
