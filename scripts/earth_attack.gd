extends Area2D

var level : int
@onready var earth: AnimatedSprite2D = $Earth
const DAMAGE = 10

func _ready() -> void:
	await earth.animation_finished
	self.queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.hit(DAMAGE)
