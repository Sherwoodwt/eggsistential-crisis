class_name Dropzone
extends Area2D

signal grabbed
signal dropped
signal placed
signal moved

var dragging: bool
var ingredient: Ingredient

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
	if Input.is_action_just_pressed("grab") and not dragging and ingredient:
		dragging = true
		ingredient.global_position = get_global_mouse_position()
		ingredient.sprite.z_index += 10
		ingredient.sprite.texture = ingredient.hover_sprite
		grabbed.emit()

func _physics_process(delta: float) -> void:
	if dragging:
		ingredient.global_position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("grab") and dragging:
		ingredient.sprite.z_index -= 10
		ingredient.sprite.texture = ingredient.placed_sprite
		dragging = false
		var dropzone = point_overlap(get_global_mouse_position())
		if dropzone and dropzone.can_place(ingredient):
			ingredient.reparent(dropzone)
			ingredient.global_position = dropzone.global_position
			dropzone.set_ingredient(ingredient)
			dropzone.placed.emit()
			moved.emit()
		else:
			ingredient.global_position = global_position
			dropped.emit()
