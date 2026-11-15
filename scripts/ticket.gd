class_name Ticket
extends Control

@onready var items: Node = $MarginContainer/VBoxContainer
@onready var highlight: AnimatedSprite2D = $Highlight

@export var ticket_item_scene: PackedScene
@export var for_order: bool
@export var sandwich: Bread
@export var customer: Customer

func _ready():
	gui_input.connect(_handle_gui_input)
	SignalBus.counter_updated.connect(check_ready)
	SignalBus.sale_made.connect(complete)
	# store sandwich in ticket and hide it
	if sandwich:
		add_child(sandwich)
		sandwich.visible = false
		set_sandwich(sandwich)

func _handle_gui_input(event: InputEvent):
	if not highlight.visible: # only when ready to go
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		highlight.hide()
		SignalBus.send_ticket.emit(self)

func set_sandwich(sandwich: Bread):
	for i in range(sandwich.ingredients.size() - 1, -1, -1): # backwards index
		var item := ticket_item_scene.instantiate() as TicketItem
		item.ingredient = sandwich.ingredients[i]
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
	if sandwiches.any(func(s): s.matches(sandwich)):
		highlight.visible = true
