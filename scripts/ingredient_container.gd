extends Area2D

@onready var contents: Sprite2D = $Contents

@export var ingredient: PackedScene
@export var amount: int

var dragging: bool
var instance: Ingredient

func _ready():
	var instance = ingredient.instantiate()
	var children = instance.get_children()
	var i = children.find_custom(func(c): return c is Sprite2D)
	if i >= 0:
		var sprite = children[i] as Sprite2D
		contents.texture = sprite.texture

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_pressed("grab") and !dragging and amount > 0:
		dragging = true
		instance = ingredient.instantiate() as Ingredient
		instance.global_position = get_global_mouse_position()
		add_sibling(instance)

func _physics_process(delta: float) -> void:
	if dragging:
		instance.global_position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("grab") and instance != null:
		dragging = false
		var query = PhysicsPointQueryParameters2D.new()
		query.position = get_global_mouse_position()
		query.collide_with_areas = true
		query.collide_with_bodies = false
		query.collision_mask = collision_layer
		var results = get_world_2d().direct_space_state.intersect_point(query)
		var filtered_results = results.filter(func(r): return r["collider"] != instance)
		if filtered_results.size() == 0:
			instance.queue_free.call_deferred()
			return
		for result in filtered_results:
			if result["collider"] == self:
				instance.queue_free.call_deferred()
