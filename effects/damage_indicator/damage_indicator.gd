extends Label


func _process(delta: float) -> void: modulate = lerp(modulate, Color(1,1,1,0), delta * 5)


func _on_timer_timeout() -> void: queue_free()
