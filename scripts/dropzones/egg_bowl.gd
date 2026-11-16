extends Dropzone

@onready var sprite: Sprite2D = $Sprite2D
@onready var progress: TextureProgressBar = $TextureProgressBar

@export var empty_bowl_sprite: Texture2D
@export var full_bowl_raw_sprite: Texture2D
@export var full_bowl_sprite: Texture2D
@export var bowl_stir_animation: Array[Texture2D]

var _holding_spoon: bool
var _start_point: float
var _last_point: float
const MAX_VALUE_CHANGE := 1.0
const STIRRING_WIDTH := 5.0

func _ready():
	super()
	placed.connect(_add_egg)
	moved.connect(_pour)

func _add_egg():
	sprite.texture = full_bowl_raw_sprite
	ingredient.visible = false
	for connection in ingredient.done_cookin.get_connections():
		ingredient.done_cookin.disconnect(connection["callable"])
	ingredient.done_cookin.connect(set_ingredient)

func _pour():
	sprite.texture = empty_bowl_sprite

func can_place(ingredient: Ingredient) -> bool:
	return ingredient.id == "egg"

# override for grabbing spoon
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if ingredient and ingredient.id != "egg": # when can you pick it up
		super(viewport, event, shape_idx)
	else:
		if Input.is_action_just_pressed("click") and ingredient:
			_holding_spoon = true
			_start_point = get_global_mouse_position().x
			_last_point = _start_point

# override for dropping spoon
func _input(event: InputEvent) -> void:
	if _holding_spoon and Input.is_action_just_released("click"):
		_holding_spoon = false
	if _holding_spoon and event is InputEventMouseMotion:
		#TODO:LEAVING OFF HERE
		var mouse_diff := (event as InputEventMouseMotion).relative.x
		var clamped_position := clampf(_last_point + mouse_diff, -STIRRING_WIDTH, STIRRING_WIDTH)
		progress.value += minf(abs(clamped_position - _last_point), MAX_VALUE_CHANGE)
		print(mouse_diff)
		_last_point = clamped_position
		if progress.value == progress.max_value:
			ingredient.cook(self)
			sprite.texture = full_bowl_sprite
