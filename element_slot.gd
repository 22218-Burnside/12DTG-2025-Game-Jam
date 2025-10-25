@tool
extends Button
@onready var button: TextureRect = $MarginContainer/Button
@onready var label: Label = $Label
var element : Element
var element_level : int = 0

func _process(_delta: float) -> void:
	if element:
		button.texture = element.element_texture
		label.text = str("Lvl:",element_level)
