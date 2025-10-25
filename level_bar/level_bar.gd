extends CanvasLayer

@onready var bar: TextureProgressBar = $Control/MarginContainer/VBoxContainer/bar
@onready var level: Label = $Control/MarginContainer/VBoxContainer/level

func _process(delta: float) -> void:
	bar.max_value = Globals.exp_to_next_level
	bar.value = lerp(bar.value,Globals.experiance,delta*10)
	level.text = str("Level " + str(Globals.level))
	
