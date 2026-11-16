class_name Cooker
extends Dropzone

@onready var smoke: GPUParticles2D = $GPUParticles2D
@onready var progress: TextureProgressBar = $TextureProgressBar

func can_place(ing: Ingredient) -> bool:
	if ing.is_edible and self.ingredient is Bread:
		return true
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

func set_ingredient(ing: Ingredient):
	if ingredient is Bread and ing is not Bread:
		(ingredient as Bread).add_ingredient(ing)
	else:
		ingredient = ing
		for connection in ingredient.done_cookin.get_connections():
			ing.done_cookin.disconnect(connection["callable"])
		ing.done_cookin.connect(done_cookin)
		ing.cook(self)
		progress.max_value = ing.timer.wait_time
		smoke.emitting = true
