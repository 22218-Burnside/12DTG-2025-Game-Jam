@tool
extends VBoxContainer
@onready var button: Button = $Button
@onready var label: Label = $Label
var element : Element
var element_level : int = 0

func _process(_delta: float) -> void:
	if element:
		button.icon = element.element_texture
		label.text = str(element.element_name, "\n", element_level)
