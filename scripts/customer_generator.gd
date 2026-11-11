class_name CustomerGenerator
extends Node

@onready var timer: Timer = $Timer

@export var min_time: float
@export var max_time: float
@export var customer_scene: PackedScene
@export var customer_sprites: Array[Texture2D]

func _ready():
	timer.timeout.connect(make_customer)
	make_customer() # first one
	_random_timer()

func make_customer():
	var customer = customer_scene.instantiate() as Customer
	customer.texture = customer_sprites[randi_range(0, customer_sprites.size()-1)]
	SignalBus.new_customer.emit(customer)

func _random_timer():
	timer.wait_time = randf_range(min_time, max_time)
	timer.start()
