extends Control
@onready var pixelate_anim: AnimationPlayer = $pixelate/pixelate_anim
@onready var buttons: Control = $buttons
@onready var credits_container: ScrollContainer = $credits
@onready var title: Control = $title
@onready var back: Button = $back

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
	CREDITS
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
	time += delta * 6.0 
	velocity = lerp(velocity, final_velocity, delta * decrease_rate)
	
	var credits_posx = (160 - (credits_container.size.x/2))
	
	for i in range(letters.size()):
		var label = letters[i]
		label.position.y = POSY + sin(time - i * intensity) * velocity 
		var dist = (label.global_position + (label.size/2)).distance_to(get_global_mouse_position()) 
		var scale_factor = clamp(1.5 - dist / 150.0, 1.0, 1.5)
		var color_factor = clamp((dist/50),0,1)
		label.modulate = lerp(Color.GOLD,Color.WHITE,color_factor)
		label.add_theme_font_size_override("font_size", CHAR_SIZE * scale_factor)
	
	match current_menu:
		menus.MAIN:
			back.position.x = lerp(back.position.x,-400.0,delta*10)
			title.position.x = lerp(title.position.x,0.0,delta*10)
			credits_container.position.x = lerp(credits_container.position.x,-400.0,delta*10)
			buttons.position.x = lerp(buttons.position.x,112.0,delta*10)
		menus.CREDITS:
			back.position.x = lerp(back.position.x,0.0,delta*10)
			title.position.x = lerp(title.position.x,400.0,delta*10)
			credits_container.position.x = lerp(credits_container.position.x,credits_posx,delta*10)
			buttons.position.x = lerp(buttons.position.x,400.0,delta*10)
			
	
func _on_play_pressed() -> void: 
	pixelate_anim.play_backwards("pixelate")
	await pixelate_anim.animation_finished
	get_tree().change_scene_to_file("res://prefabs/world.tscn")
func _on_credits_pressed() -> void: current_menu = menus.CREDITS
func _on_back_pressed() -> void: current_menu = menus.MAIN
