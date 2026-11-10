class_name Clickzone
extends Area2D

@onready var animator: AnimatedSprite2D = $Highlight

var entered: bool

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	entered = true

func _on_mouse_exited() -> void:
	entered = false

func _input(event: InputEvent) -> void:
	if entered and Input.is_action_just_pressed("click"):
		do_action()

func do_action():
	pass
