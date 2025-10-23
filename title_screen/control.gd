extends Control
@onready var pixelate_anim: AnimationPlayer = $pixelate/pixelate_anim
@onready var buttons: Control = $buttons
@onready var credits_container: ScrollContainer = $credits
@onready var title: Control = $title
@onready var back: Button = $back
@onready var options: CenterContainer = $options
@onready var forward: Button = $forward
@onready var master_volume_slider: HSlider = $options/VBoxContainer/master_volume/master_volume_slider

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
	velocity = initial_velocity
	
	for i in range(title_text.length()):
		var label = Label.new()
		label.text = str(title_text[i])
		label.theme = load("res://theme.tres")
		label.add_theme_font_size_override("font_size", CHAR_SIZE)
		label.position = Vector2((i * SPACING )+ POSX, POSY)
		title.add_child(label)
		letters.append(label)

func _process(delta: float) -> void:
	master_volume_slider.pivot_offset = master_volume_slider.size/2
	master_volume_slider.rotation = lerp(master_volume_slider.rotation,0.0,delta*10)
	master_volume_slider.scale = lerp(master_volume_slider.scale,Vector2.ONE,delta*10)
	Settings.master_volume = master_volume_slider.value
	
	time += delta * 6.0 
	velocity = lerp(velocity, final_velocity, delta * decrease_rate)
	
	var credits_posx = (160 - (credits_container.size.x/2))
	
	for i in range(letters.size()):
		var label = letters[i]
		label.position.y = POSY + sin(time - i * intensity) * velocity 
		var dist = (label.global_position + (label.size/2)).distance_to(get_global_mouse_position()) 
		var scale_factor = clamp(1.5 - dist / 150.0, 1.0, 1.5)
		var color_factor = clamp((dist/50),0,1)
		label.modulate = lerp(Color.CORNFLOWER_BLUE,Color.WHITE,color_factor)
		label.add_theme_font_size_override("font_size", CHAR_SIZE * scale_factor)
	
	match current_menu:
		menus.MAIN:
			title.position.x = lerp(title.position.x,0.0,delta*10)
			buttons.position.x = lerp(buttons.position.x,112.0,delta*10)
			
			back.position.x = lerp(back.position.x,-400.0,delta*10)
			credits_container.position.x = lerp(credits_container.position.x,-400.0,delta*10)
			
			forward.position.x = lerp(forward.position.x,400.0,delta*10)
			options.position.x = lerp(options.position.x, 400.0, delta *10)
			
		menus.CREDITS:
			title.position.x = lerp(title.position.x,400.0,delta*10)
			buttons.position.x = lerp(buttons.position.x,400.0,delta*10)
			
			back.position.x = lerp(back.position.x,0.0,delta*10)
			credits_container.position.x = lerp(credits_container.position.x,credits_posx,delta*10)
		
			forward.position.x = lerp(forward.position.x,800.0,delta*10)
			options.position.x = lerp(options.position.x, 800.0, delta *10)
			
		menus.OPTIONS:
			title.position.x = lerp(title.position.x,-400.0,delta*10)
			buttons.position.x = lerp(buttons.position.x,-400.0,delta*10)
			
			back.position.x = lerp(back.position.x,-800.0,delta*10)
			credits_container.position.x = lerp(credits_container.position.x,-800.0,delta*10)
						
			forward.position.x = lerp(forward.position.x,0.0,delta*10)
			options.position.x = lerp(options.position.x, 0.0, delta *10)
			
	
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
