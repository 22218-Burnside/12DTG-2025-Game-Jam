@tool
extends VBoxContainer
@onready var button: Button = $Button
@onready var label: Label = $Label
@export var slot_id : int = 0 
@export var element : Element
@export var element_level : int = 1

func _process(_delta: float) -> void:
	if element:
		button.icon = element.element_texture
		label.text = str(element.element_name, " LVL", element_level)
