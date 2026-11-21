class_name Dropzone
extends Area2D

signal grabbed # item picked up off of this zone
signal dropped # item that was grabbed was let go and not moved
signal placed # item moved to this zone
signal moved # item moved away from this zone

@onready var highlight: AnimatedSprite2D = $Highlight
@onready var hover_animation: Sprite2D = $HoverAnimation
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var id: String

var disabled: bool
var dragging: bool # dropzone's ingredient being moved
var hovering: bool # cursor overlapping area
var ingredient: Ingredient

var currently_held: Ingredient

func _ready():
	SignalBus.ingredient_grabbed.connect(func(i): currently_held = i)
	SignalBus.ingredient_dropped.connect(_on_ingredient_dropped)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_ingredient_dropped():
	currently_held = null
	hover_animation.hide()

func _on_mouse_entered():
	if currently_held != null and can_place(currently_held):
		currently_held.hide()
		hover_animation.texture = currently_held.placed_sprite
		hover_animation.show()

func _on_mouse_exited():
	if currently_held:
		currently_held.show()
		hover_animation.hide()

func can_place(ingredient: Ingredient) -> bool:
	return true

func set_ingredient(ingredient: Ingredient):
	self.ingredient = ingredient
	audio.play()

# Determines if the point overlaps with a dropzone, used for placing
func point_overlap(point: Vector2) -> Dropzone:
	var query = PhysicsPointQueryParameters2D.new()
	query.position = point
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = collision_layer
	var results: Array[Dictionary] = get_world_2d().direct_space_state.intersect_point(query)
	var result = results.find_custom(func(r): return r["collider"] is Dropzone)
	if result < 0:
		return null
	return results[result]["collider"] as Dropzone

# Called on mouse input
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if disabled: return
	if Input.is_action_just_pressed("click") and not dragging and ingredient:
		dragging = true
		ingredient.global_position = get_global_mouse_position()
		ingredient.sprite.move_to_front()
		ingredient.sprite.z_index = 10
		ingredient.sprite.texture = ingredient.hover_sprite
		grabbed.emit()
		SignalBus.ingredient_grabbed.emit(ingredient)

func _physics_process(delta: float) -> void:
	if dragging:
		ingredient.global_position = get_global_mouse_position()

# Handle place (move to new spot), drop (place in invalid spot), deselect
func _input(event: InputEvent) -> void:
	if disabled: return
	var is_drop = Input.is_action_just_released("click")
	#var is_deselect = Input.is_action_just_pressed("deselect")
	if is_drop and dragging:
		hover_animation.hide()
		if currently_held:
			currently_held.show()
		ingredient.sprite.texture = ingredient.placed_sprite
		ingredient.sprite.z_index = 0
		dragging = false
		var dropzone = point_overlap(get_global_mouse_position())
		if dropzone and dropzone.can_place(ingredient):
			ingredient.reparent(dropzone)
			ingredient.scale = dropzone.scale
			ingredient.global_position = dropzone.global_position
			dropzone.set_ingredient(ingredient)
			dropzone.placed.emit()
			moved.emit()
			SignalBus.ingredient_dropped.emit()
		else:
			ingredient.global_position = global_position
			ingredient.sprite.z_index = 0
			dropped.emit()
			SignalBus.ingredient_dropped.emit()
	#elif is_deselect and dragging:
		#dragging = false
		#ingredient.global_position = global_position
		#ingredient.sprite.z_index = 0
		#dropped.emit()
