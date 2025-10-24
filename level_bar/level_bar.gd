extends CanvasLayer

@onready var bar: TextureProgressBar = $Control/MarginContainer/VBoxContainer/bar
@onready var level: Label = $Control/MarginContainer/VBoxContainer/level

func _process(delta: float) -> void:
	
	bar.value = Globals.experiance
	bar.max_value = Globals.exp_to_next_level
	level.text = str("Level " + str(Globals.level))
	
