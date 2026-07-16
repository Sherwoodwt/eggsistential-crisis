extends Node

@onready var timer: Timer = $Timer
@onready var customer: Sprite2D = $Customer/Sprite2D
@onready var tickets: Array[Order] = [$Tickets/Ticket, $Tickets/Ticket2, $Tickets/Ticket3, $Tickets/Ticket4]

@export var customer_sprites: Array[Texture2D]
@export var min_time: float
@export var max_time: float
@export var breads: Array[PackedScene]
@export var sauces: Array[PackedScene]
@export var eggs: Array[PackedScene]
@export var toppings: Array[PackedScene]

func _ready():
	timer.timeout.connect(make_customer)
	_random_timer()

func make_customer():
	customer.texture = customer_sprites[randi_range(0, customer_sprites.size()-1)]
	var ticket = tickets[0] # TODO: Eventually add tickets
	var sandwich_count = randi_range(1, 4)
	for i in range(sandwich_count):
		var sandwich = random_sandwich()
		ticket.sandwiches.append(sandwich)
		ticket.new_ticket()

func random_sandwich() -> Bread:
	var bread = breads.pick_random().instantiate() as Bread
	if randf() > .5:
		bread.ingredients.append(sauces.pick_random().instantiate())
	bread.ingredients.append(eggs.pick_random().instantiate())
	var topping_count = randi_range(0, toppings.size())
	var topping_copy = toppings
	for i in range(topping_count):
		var topping = topping_copy.pop_at(randi_range(0, topping_copy.size()-1)).instantiate()
		bread.ingredients.append(topping)
	return bread

func _random_timer():
	# TODO: for debug, remove
	#timer.wait_time = randf_range(min_time, max_time)
	timer.start()
