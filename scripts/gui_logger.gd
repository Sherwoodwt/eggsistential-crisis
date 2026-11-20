extends Node

@onready var floating_text: PackedScene = preload("res://scenes/floating_text.tscn") as PackedScene

# return instantiated FloatingText to add to tree
func print(text: String, color: Color = Color.GREEN) -> FloatingText:
	var inst := floating_text.instantiate() as FloatingText
	inst.text =  text
	inst.color = color
	return inst
