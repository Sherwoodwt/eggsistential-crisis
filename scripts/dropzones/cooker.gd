class_name Cooker
extends Dropzone

@onready var smoke: GPUParticles2D = $GPUParticles2D
@onready var progress: TextureProgressBar = $TextureProgressBar

@export var id: String

func can_place(ing: Ingredient) -> bool:
	if ing is Bread and (ing as Bread).ingredients.size() > 1:
		return false
	var index = ing.cook_methods.find_custom(func(m): return m.cooker == id)
	return !ingredient and index >= 0

func _ready():
	super()
	grabbed.connect(_on_grabbed)
	moved.connect(_on_moved)
	dropped.connect(_on_dropped)

func _on_dropped():
	smoke.emitting = true
	progress.visible = true
	ingredient.cook(self)

func _on_grabbed():
	ingredient.stop_cookin()
	highlight.visible = false
	progress.visible = false
	smoke.emitting = false

func _on_moved():
	ingredient = null

func _process(delta: float) -> void:
	if ingredient and !ingredient.timer.paused:
		progress.visible = true
		progress.value = ingredient.timer.wait_time - ingredient.timer.time_left

func done_cookin(result: Ingredient):
	set_ingredient(result)
	progress.hide()
	highlight.visible = result.is_edible

func set_ingredient(ingredient: Ingredient):
	self.ingredient = ingredient
	for connection in ingredient.done_cookin.get_connections():
		ingredient.done_cookin.disconnect(connection["callable"])
	ingredient.done_cookin.connect(done_cookin)
	ingredient.cook(self)
	progress.max_value = ingredient.timer.wait_time
	smoke.emitting = true
