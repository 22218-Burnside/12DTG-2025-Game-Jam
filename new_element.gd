extends Control

var new_element : Element
@onready var icon: TextureRect = $NinePatchRect/MarginContainer/VBoxContainer/icon
@onready var element_name: RichTextLabel = $NinePatchRect/MarginContainer/VBoxContainer/name2

func _process(delta: float) -> void:
	new_element = get_parent().get_parent().queued_new_element
	
	#print(new_element)
	
	if new_element:
		icon.texture = new_element.element_texture
		element_name.text = str("[outline_size=8][wave][color=red]" + new_element.element_name)
