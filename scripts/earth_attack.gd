extends Area2D

var level : int

func _ready() -> void:
	$Timer.start(5)


func _on_timer_timeout() -> void:
	self.queue_free()
