extends TextureRect

@onready var timer: Timer = $Timer




func _ready() -> void:
	pivot_offset = size / 2
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _process(delta: float) -> void:
	scale = lerp(scale,Vector2.ONE,delta*10)
	
	if Input.is_action_just_pressed("click"):
		scale = Vector2(0.2,0.2)
	
	position = get_global_mouse_position() #- size/2
