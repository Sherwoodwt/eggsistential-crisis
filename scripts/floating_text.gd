class_name FloatingText
extends Label

const SPEED = 20

@onready var timer: Timer = $Timer

@export var ttl: float = 2.0
@export var color: Color = Color.GREEN

func _ready():
	add_theme_color_override("font_color", color)
	timer.wait_time = ttl
	timer.timeout.connect(func(): queue_free())
	timer.start()

func _process(delta: float) -> void:
	global_position.y -= SPEED * delta
	add_theme_color_override("font_color", Color(color, lerpf(0, 1, timer.time_left / timer.wait_time)))
