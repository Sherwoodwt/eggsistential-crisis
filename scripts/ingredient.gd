class_name Ingredient
extends Area2D



@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

@export var id: String
@export var is_bread: bool
@export var is_edible: bool
@export var burn_time: float
@export var burnt: Texture2D

var moving: bool

func _ready():
	timer.wait_time = burn_time
	timer.timeout.connect(_burn)

func cook(cooker: Cooker):
	timer.start()

func _burn():
	sprite.texture = burnt
	is_edible = false
	timer.stop()
