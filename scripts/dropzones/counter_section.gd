class_name CounterSection
extends Dropzone

@onready var wrapping: Texture2D = preload("res://sprites/wrapped_sandwich.png") as Texture2D
@onready var ingredient_list: Ticket = $IngredientList

func _ready():
	super()
	placed.connect(_on_placed)
	moved.connect(_on_moved)
	dropped.connect(_on_dropped)
	SignalBus.ticket_highlighted.connect(_on_highlight)
	SignalBus.ticket_unhighlighted.connect(_on_unhighlight)
	SignalBus.send_ticket.connect(_ticket_sent)

func can_place(ingredient: Ingredient) -> bool:
	return ingredient is Bread and self.ingredient == null

func _on_placed():
	var bread = self.ingredient as Bread
	bread.sprite.texture = wrapping
	bread.global_scale = global_scale
	for ing in bread.ingredients:
		ing.visible = ing == bread

func _on_moved():
	ingredient = null

func _on_dropped():
	self.ingredient.sprite.texture = wrapping

func _on_highlight(ticket: Ticket):
	if ticket.sandwich_match == ingredient:
		highlight.show()

func _on_unhighlight(ticket: Ticket):
	if ticket.sandwich_match == ingredient:
		highlight.hide()

func _ticket_sent(ticket: Ticket):
	if ticket.sandwich_match == ingredient:
		highlight.hide()
		ingredient.sprite.modulate = Color.WEB_GRAY

func _on_mouse_entered():
	super()
	if hover_animation.visible:
		hover_animation.texture = wrapping
	if ingredient:
		ingredient_list.show()
		ingredient_list.set_sandwich(ingredient)

func _on_mouse_exited():
	super()
	ingredient_list.hide()
	ingredient_list.clear_sandwich()
