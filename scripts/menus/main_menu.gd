extends Node2D

@onready var game_scene: PackedScene = preload("res://scenes/main_area.tscn") as PackedScene
@onready var new_game: Button = $CanvasLayer/MainMenu/VBoxContainer/Button
@onready var exit: Button = $CanvasLayer/MainMenu/VBoxContainer/Button2
@onready var main_menu: Control = $CanvasLayer/MainMenu

@onready var fail_screen_button: Button = $CanvasLayer/FailScreen/VBoxContainer/Button
@onready var fail_screen: Control = $CanvasLayer/FailScreen

var game: Node

func _ready():
	new_game.pressed.connect(_start_game)
	exit.pressed.connect(_exit)
	fail_screen_button.pressed.connect(func(): SignalBus.quit.emit())
	SignalBus.quit.connect(_quit_to_menu)
	SignalBus.lose.connect(_open_fail_screen)

func _start_game():
	game = game_scene.instantiate() as Node
	add_child(game)
	main_menu.hide()

func _exit():
	get_tree().quit()

func _open_fail_screen():
	get_tree().paused = true
	game.hide()
	fail_screen.show()

func _quit_to_menu():
	get_tree().paused = false
	fail_screen.hide()
	game.queue_free()
	main_menu.show()
