extends Control

@onready var continue_button: Button = $VBoxContainer/Button
@onready var exit_button: Button = $VBoxContainer/Button2

func _ready():
	continue_button.pressed.connect(_on_continue)
	exit_button.pressed.connect(_on_exit)

func _on_continue():
	hide()
	get_tree().paused = false

func _on_exit():
	hide()
	get_tree().paused = false
	SignalBus.quit.emit()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		visible = !visible
		get_tree().paused = visible
