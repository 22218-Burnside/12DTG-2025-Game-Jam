extends Button
@onready var icon_texture: TextureRect = $NinePatchRect/MarginContainer/HBoxContainer/icon
@onready var name_label: RichTextLabel = $NinePatchRect/MarginContainer/HBoxContainer/VBoxContainer/name
@onready var desc_label: Label = $NinePatchRect/MarginContainer/HBoxContainer/VBoxContainer/upgrade_desc

var upgrade_icon
var upgrade_name
var upgrade_desc : String = "Upgrade stuff"
var hovered = false

const HOVER_SCALE : float = 1.1

func _process(delta: float) -> void:
	if upgrade_icon: icon_texture.texture = upgrade_icon
	if upgrade_name: name_label.text = str("[wave][outline_size=16]"+upgrade_name)
	if upgrade_desc: desc_label.text = upgrade_desc
	
	pivot_offset = size/2
	
	if hovered: 
		desc_label.modulate = lerp(desc_label.modulate,Color(1,1,1,1),delta*10)
		scale = lerp(scale,Vector2(HOVER_SCALE,HOVER_SCALE),delta*10)
	else: 
		desc_label.modulate = lerp(desc_label.modulate,Color(1,1,1,0),delta*10)
		scale = lerp(scale,Vector2(1,1),delta*10)
	
func _on_mouse_entered() -> void: hovered = true
func _on_mouse_exited() -> void: hovered = false
