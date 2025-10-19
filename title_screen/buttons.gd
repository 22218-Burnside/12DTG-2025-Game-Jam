extends Control

@onready var play: Button = $PLAY
@onready var options: Button = $OPTIONS
@onready var credits: Button = $CREDITS
@onready var quit: Button = $QUIT

var play_hover : bool = false
var options_hover : bool = false
var credits_hover : bool = false
var quit_hover : bool = false

const HOVER_SCALE := 1.2
const SCALE_DELTA_MOD := 5

func _ready() -> void:
	play.pivot_offset = play.size/2
	options.pivot_offset = options.size/2
	credits.pivot_offset = credits.size/2
	quit.pivot_offset = quit.size/2

func _process(delta: float) -> void:
	if play_hover: play.scale = lerp(play.scale,Vector2(HOVER_SCALE,HOVER_SCALE),SCALE_DELTA_MOD * delta)
	else: play.scale = lerp(play.scale,Vector2.ONE,SCALE_DELTA_MOD * delta)
	
	if options_hover: options.scale = lerp(options.scale,Vector2(HOVER_SCALE,HOVER_SCALE),SCALE_DELTA_MOD * delta)
	else: options.scale = lerp(options.scale,Vector2.ONE,SCALE_DELTA_MOD * delta)
	
	if credits_hover: credits.scale = lerp(credits.scale,Vector2(HOVER_SCALE,HOVER_SCALE),SCALE_DELTA_MOD * delta)
	else: credits.scale = lerp(credits.scale,Vector2.ONE,SCALE_DELTA_MOD * delta)
	
	if quit_hover: quit.scale = lerp(quit.scale,Vector2(HOVER_SCALE,HOVER_SCALE),SCALE_DELTA_MOD * delta)
	else: quit.scale = lerp(quit.scale,Vector2.ONE,SCALE_DELTA_MOD * delta)
	
func _on_play_mouse_entered() -> void: play_hover = true
func _on_play_mouse_exited() -> void: play_hover = false

func _on_options_mouse_entered() -> void: options_hover = true
func _on_options_mouse_exited() -> void: options_hover = false

func _on_credits_mouse_entered() -> void: credits_hover = true
func _on_credits_mouse_exited() -> void: credits_hover = false

func _on_quit_mouse_entered() -> void: quit_hover = true
func _on_quit_mouse_exited() -> void: quit_hover = false
