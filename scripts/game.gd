extends Node

@onready var ui_score: Label = $CanvasLayer/Score

var sale_count := 0

func _ready():
	SignalBus.sale_made.connect(_refresh)

func _refresh():
	sale_count += 1
	ui_score.text = "SERVED: %d" % sale_count
