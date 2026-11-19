class_name Ticket
extends Control

@onready var items: Node = $MarginContainer/VBoxContainer
@onready var highlight: AnimatedSprite2D = $Highlight
@onready var button: Button = $Button
@onready var progress: TextureProgressBar = $TextureProgressBar
@onready var timer: Timer = $Timer

@export var time: float
@export var ticket_item_scene: PackedScene
@export var for_order: bool
@export var sandwich: Bread
@export var customer: Customer

func _ready():
	if for_order:
		timer.wait_time = time
		timer.timeout.connect(_fail_ticket)
		timer.start()
		progress.visible = true
		progress.max_value = time
		progress.value = progress.max_value
	button.pressed.connect(_handle_click)
	SignalBus.counter_updated.connect(check_ready)
	SignalBus.sale_made.connect(complete)
	# store sandwich in ticket and hide it
	if sandwich:
		add_child(sandwich)
		sandwich.visible = false
		set_sandwich(sandwich)

func _process(delta: float) -> void:
	if for_order:
		progress.value = timer.time_left

func _handle_click():
	if not highlight.visible: # only when ready to go
		return
	highlight.hide()
	timer.stop()
	SignalBus.send_ticket.emit(self)

func set_sandwich(sandwich: Bread):
	for i in range(sandwich.ingredients.size() - 1, -1, -1): # backwards index
		var already_included := false
		var ing = sandwich.ingredients[i]
		for ticket_item: TicketItem in items.get_children(): # increment if already exists
			if ticket_item.ingredient.id == ing.id:
				ticket_item.add_count()
				already_included = true
		if not already_included:
			var item := ticket_item_scene.instantiate() as TicketItem
			item.ingredient = ing
			items.add_child(item)

# used for ingredient list
func clear_sandwich():
	for item in items.get_children():
		item.queue_free()

func complete(customer: Customer):
	if self.customer == customer:
		print("ticket complete")
		sandwich.queue_free()
		visible = false

func check_ready(sandwiches: Array[Bread]):
	if !for_order: return
	if sandwiches.any(func(s): return s.matches(sandwich)):
		highlight.visible = true

func _fail_ticket():
	timer.stop()
	SignalBus.ticket_expired.emit(self)
