class_name Ticket
extends Control

const DEFAULT_SANDWICH_PRICE = 5

@onready var highlight_shader: Shader = preload("res://shaders/ready.gdshader")
@onready var items: Node = $MarginContainer/VBoxContainer
@onready var button: Button = $Button
@onready var progress: TextureProgressBar = $TextureProgressBar
@onready var timer: Timer = $Timer

@export var time: float
@export var ticket_item_scene: PackedScene
@export var for_order: bool
@export var sandwich: Bread
@export var customer: Customer
@export var sandwich_match: Bread
@export var sandwich_match_score: int

var highlight: ShaderMaterial
var original_height: float
var shifted_height: float
var sent: bool

func _ready():
	original_height = global_position.y
	shifted_height = global_position.y + 10
	highlight = ShaderMaterial.new()
	highlight.shader = highlight_shader
	if for_order:
		timer.wait_time = time
		timer.timeout.connect(_fail_ticket)
		timer.start()
		progress.visible = true
		progress.max_value = time
		progress.value = progress.max_value
	button.mouse_entered.connect(_mouse_entered)
	button.mouse_exited.connect(_mouse_exited)
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

func _mouse_entered():
	if material:
		global_position.y = shifted_height
		SignalBus.ticket_highlighted.emit(self)

func _mouse_exited():
	if not sent:
		global_position.y = original_height
		SignalBus.ticket_unhighlighted.emit(self)

func _handle_click():
	if not material: # only when ready to go
		return
	sent = true
	material = null
	_mouse_exited()
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

func complete(ticket: Ticket):
	if self.customer == ticket.customer:
		print("ticket complete")
		sandwich.queue_free()
		visible = false

func check_ready(sandwiches: Array[Bread]):
	if !for_order or sent: return
	var best_score: int = -1
	var best_sandwich: Bread = null
	for sand in sandwiches:
		var score := sandwich.compare_differences(sand)
		if best_sandwich == null or score < best_score:
			best_score = score
			best_sandwich = sand
	if best_sandwich:
		sandwich_match = best_sandwich
		sandwich_match_score = best_score
		material = highlight
	else:
		sandwich_match = null
		sandwich_match_score = -1
		material = null

# TODO: Calculate based on ingredient cost
func get_price() -> int:
	return DEFAULT_SANDWICH_PRICE

func _fail_ticket():
	timer.stop()
	SignalBus.ticket_expired.emit(self)
