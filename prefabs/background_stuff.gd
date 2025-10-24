extends Node2D

@onready var clouds: TextureRect = $clouds

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	clouds.position.x += delta * 300
	
	if clouds.position.x >= clouds.size.x: clouds.position.x = 0
