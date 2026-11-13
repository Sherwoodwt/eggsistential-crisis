class_name Dropzone
extends Area2D

signal grabbed # item picked up off of this zone
signal dropped # item that was grabbed was let go and not moved
signal placed # item moved to this zone
signal moved # item moved away from this zone

@onready var highlight: AnimatedSprite2D = $Highlight

@export var draggable: bool

var disabled: bool
var dragging: bool
var ingredient: Ingredient
var just_placed: bool

func _ready():
	placed.connect(func(): just_placed = true)

func can_place(ingredient: Ingredient) -> bool:
	return true

func set_ingredient(ingredient: Ingredient):
	self.ingredient = ingredient

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

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if disabled: return
	if Input.is_action_just_pressed("click") and not dragging and ingredient:
		#if just_placed:
			#just_placed = false
			#return
		dragging = true
		ingredient.global_position = get_global_mouse_position()
		ingredient.sprite.move_to_front()
		ingredient.sprite.z_index = 10
		ingredient.sprite.texture = ingredient.hover_sprite
		grabbed.emit()

func _physics_process(delta: float) -> void:
	if dragging:
		ingredient.global_position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if disabled: return
	var is_drop = Input.is_action_just_released("click") if draggable \
		else Input.is_action_just_pressed("click")
	var is_deselect = Input.is_action_just_pressed("deselect")
	if is_drop and dragging:
		ingredient.sprite.texture = ingredient.placed_sprite
		ingredient.sprite.z_index = 0
		dragging = false
		var dropzone = point_overlap(get_global_mouse_position())
		if dropzone and dropzone.can_place(ingredient):
			if !draggable:
				dragging = true
			ingredient.reparent(dropzone)
			ingredient.scale = dropzone.scale
			ingredient.global_position = dropzone.global_position
			dropzone.set_ingredient(ingredient)
			dropzone.placed.emit()
			moved.emit()
		else:
			ingredient.global_position = global_position
			dropped.emit()
	elif is_deselect and dragging:
		dragging = false
		ingredient.global_position = global_position
		ingredient.sprite.z_index = 0
		dropped.emit()
