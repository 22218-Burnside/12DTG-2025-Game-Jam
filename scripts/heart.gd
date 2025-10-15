extends Area2D
var heal_amount = 10
func _ready() -> void:
	$despawn_timer.start(5)
func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		if body.health < 100:
			body.health += heal_amount
			body.update_stats()
			self.queue_free()


func _on_despawn_timer_timeout() -> void:
	self.queue_free()
