class_name Counter
extends Node

signal placed(orders: Array[Ticket])

var counters: Array[CounterSection]

func _ready():
	counters.assign(get_children().filter(func(c): return c is CounterSection))
	for counter in counters:
		counter.placed.connect(func(): placed.emit())
