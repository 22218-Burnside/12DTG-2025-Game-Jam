extends Area2D

var level : int
@onready var earth: AnimatedSprite2D = $Earth

func _ready() -> void:
	$Timer.start(5)


func _on_timer_timeout() -> void:
	await earth.animation_finished
	self.queue_free()
