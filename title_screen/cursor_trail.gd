extends TextureRect


func _ready() -> void:
	scale.x = randi_range(1,2)
	scale.y = scale.x
	pivot_offset = size/2
	

func _process(delta: float) -> void:
	position.y += 1
	rotation += 2 * delta
	scale = lerp(scale,Vector2(0,0),delta)


func _on_timer_timeout() -> void:
	queue_free()
