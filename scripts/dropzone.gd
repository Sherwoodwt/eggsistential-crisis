class_name Dropzone
extends Area2D

signal grabbed
signal dropped
signal placed
signal moved

var dragging: bool
var ingredient: Ingredient

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
		grabbed.emit()

func _physics_process(delta: float) -> void:
	if dragging:
		ingredient.global_position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("grab") and dragging:
		dragging = false
		var dropzone = point_overlap(get_global_mouse_position())
		if dropzone and ingredient.can_place(dropzone):
			ingredient.reparent(dropzone)
			ingredient.global_position = dropzone.global_position
			dropzone.ingredient = ingredient
			dropzone.placed.emit()
			ingredient = null
			moved.emit()
		else:
			ingredient.global_position = global_position
			dropped.emit()
