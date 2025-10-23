extends Control

@onready var pixelate_anim: AnimationPlayer = $pixelate/pixelate_anim
@onready var earth: ColorRect = $earth

# main
@onready var _main_container: Control = $menus/main

@onready var buttons: Control = $menus/main/buttons
#@onready var title: Control = $menus/main/title

# options
@onready var _options_container: VBoxContainer = $menus/options


@onready var options: CenterContainer = $menus/options/options
@onready var forward: Button = $menus/options/forward
@onready var master_volume_slider: HSlider = $menus/options/options/VBoxContainer/master_volume/master_volume_slider
@onready var ui_scale_slider: HSlider = $menus/options/options/VBoxContainer/ui_scale/ui_scale_slider

# credits
@onready var _credits_container: VBoxContainer = $menus/credits
@onready var menus_container: HBoxContainer = $menus
@onready var credits: ScrollContainer = $menus/credits/credits
@onready var names: VBoxContainer = $menus/credits/credits/names


@onready var back: Button = $menus/credits/back
@onready var credits_container: Control = $menus/credits/credits 

@export var initial_velocity : float
@export var intensity : float 
@export var decrease_rate : float
@export var final_velocity : float

var title_text = "ACROPOLIS"
var velocity: float = 300.0
var time: float = 0.0
var letters: Array = []

const CHAR_SIZE = 48
const POSY = 35
const SPACING = 32
const POSX = 18



var current_menu = menus.MAIN
enum menus {
	MAIN,
	CREDITS,
	OPTIONS
}

func _ready() -> void:
	credits.custom_minimum_size.y = (get_viewport_rect().size.y - back.size.y)
	names.custom_minimum_size.x = get_viewport_rect().size.x
	
	earth.size.x = earth.size.y
	earth.position.x = (get_viewport_rect().size.x/2) - (earth.size.x/2)
	
	for node in get_all_nodes(self):
		if node is Button:
			node.pivot_offset = node.size/2
	
	_main_container.custom_minimum_size = get_viewport_rect().size
	_options_container.custom_minimum_size = get_viewport_rect().size
	_credits_container.custom_minimum_size = get_viewport_rect().size
	
	velocity = initial_velocity

	Settings.ui_scale = ui_scale_slider.value
	await get_tree().process_frame
	ThemeManager.update()

func _process(delta: float) -> void:
	master_volume_slider.pivot_offset = master_volume_slider.size/2
	master_volume_slider.rotation = lerp(master_volume_slider.rotation,0.0,delta*10)
	master_volume_slider.scale = lerp(master_volume_slider.scale,Vector2.ONE,delta*10)
	Settings.master_volume = master_volume_slider.value
	
	ui_scale_slider.pivot_offset = ui_scale_slider.size/2
	ui_scale_slider.rotation = lerp(ui_scale_slider.rotation,0.0,delta*10)
	ui_scale_slider.scale = lerp(ui_scale_slider.scale,Vector2.ONE,delta*10)
	Settings.ui_scale = ui_scale_slider.value
	
	time += delta * 6.0 
	velocity = lerp(velocity, final_velocity, delta * decrease_rate)
	
	#var credits_posx = (160 - (credits_container.size.x/2))
	
		
	var target = 0.0
	match current_menu:
		menus.MAIN:
			target = -(get_viewport_rect().size.x)
		menus.OPTIONS:
			target = -(get_viewport_rect().size.x) * 2
	
	menus_container.position.x = lerp(menus_container.position.x,target,delta*10)
	
			
	
func _on_play_pressed() -> void: 
	pixelate_anim.play_backwards("pixelate")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	await pixelate_anim.animation_finished
	get_tree().change_scene_to_file("res://prefabs/world.tscn")
	
func _on_credits_pressed() -> void: current_menu = menus.CREDITS
func _on_back_pressed() -> void: current_menu = menus.MAIN
func _on_options_pressed() -> void: current_menu = menus.OPTIONS
func _on_forward_pressed() -> void: current_menu = menus.MAIN

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_master_volume_slider_value_changed(value: float) -> void:
	var new_val = ((value + 80) / 80)
	
	master_volume_slider.scale.x = (new_val/10) + 1
	master_volume_slider.scale.y = master_volume_slider.scale.x
	master_volume_slider.rotation = randf_range(-new_val/10,new_val/10)


func _on_ui_scale_slider_value_changed(value: float) -> void:
	ThemeManager.update()
	var new_val = (value / 2)
	
	ui_scale_slider.scale.x = (new_val/10) + 1
	ui_scale_slider.scale.y = ui_scale_slider.scale.x
	ui_scale_slider.rotation = randf_range(-new_val/10,new_val/10)

func get_all_nodes(root: Node) -> Array:
	var result: Array = [root]
	
	for child in root.get_children():
		if child is Node:
			result += get_all_nodes(child)
	
	return result
