class_name Ticket
extends Control

@onready var rows: Array[Node] = $MarginContainer/VBoxContainer.get_children()
@onready var highlight: AnimatedSprite2D = $Highlight

@export var for_order: bool
@export var sandwiches: Array[Bread]
@export var customer: Customer

func _ready():
	gui_input.connect(_handle_gui_input)
	SignalBus.counter_updated.connect(check_ready)
	SignalBus.sale_made.connect(complete)
	var cur := 0
	for sandwich in sandwiches:
		add_child(sandwich)
		sandwich.visible = false
		for i in range(sandwich.ingredients.size()):
			var sprite = TextureRect.new()
			sprite.texture = sandwich.ingredients[sandwich.ingredients.size() - 1 - i].icon_sprite
			sprite.expand_mode = TextureRect.EXPAND_FIT_WIDTH
			rows[cur].add_child(sprite)
		cur += 1

func _handle_gui_input(event: InputEvent):
	if not highlight.visible: # only when ready to go
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		highlight.hide()
		SignalBus.send_ticket.emit(self)

# used for ingredient list
func set_sandwich(sandwich: Bread):
	for i in range(sandwich.ingredients.size()):
		var sprite = TextureRect.new()
		sprite.texture = sandwich.ingredients[sandwich.ingredients.size() - 1 - i].icon_sprite
		sprite.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		rows[0].add_child(sprite)

# used for ingredient list
func clear_sandwich():
	for child in rows[0].get_children():
		rows[0].remove_child(child)

func complete(customer: Customer):
	if self.customer == customer:
		print("ticket complete")
		sandwiches.clear()
		visible = false

func check_ready(sandwiches: Array[Bread]):
	if !for_order: return
	var used: Array[Bread] = []
	for req_sandwich in self.sandwiches:
		for sandwich in sandwiches:
			if not used.has(sandwich) and req_sandwich.matches(sandwich):
				used.append(sandwich)
	highlight.visible = used.size() == self.sandwiches.size()
