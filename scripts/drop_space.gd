class_name DropSpace
extends Area2D

var hover_ingredient: Ingredient
var dragging: bool
var ingredient: Ingredient

func contains_point(point: Vector2) -> bool:
	var query = PhysicsPointQueryParameters2D.new()
	query.position = point
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = collision_layer
	var results: Array[Dictionary] = get_world_2d().direct_space_state.intersect_point(query)
	
	for result in results:
		if result["collider"] == self:
			return true
	return false

func _ready():
	input_event.connect(_on_input_event)

func _on_area_entered(area: Area2D) -> void:
	if area is Ingredient and hover_ingredient == null:
		hover_ingredient = area as Ingredient

func _on_area_exited(area: Area2D) -> void:
	if area is Ingredient and hover_ingredient != null:
		hover_ingredient = null

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if Input.is_action_pressed("grab") and !dragging and ingredient != null:
		dragging = true
		ingredient.global_position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("grab"):
		if hover_ingredient != null and ingredient == null:
			if contains_point(get_global_mouse_position()):
				_on_drop()
		if ingredient != null:
			dragging = false
			ingredient.global_position = Vector2.ZERO

func _on_drop():
	ingredient = hover_ingredient
	ingredient.position = Vector2.ZERO
	ingredient.reparent(self, false)

func _physics_process(delta: float) -> void:
	if dragging:
		ingredient.global_position = get_global_mouse_position()
