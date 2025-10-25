extends CanvasLayer

@onready var control: Control = $Control

func _process(delta: float) -> void:
	control.pivot_offset = control.size/2
	
	if visible: control.scale = lerp(control.scale,Vector2(1,1),delta*10)
	else: control.scale = Vector2(0,0)
