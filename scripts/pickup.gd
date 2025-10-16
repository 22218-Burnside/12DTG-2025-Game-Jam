extends Area2D
@export var amount: int = 10
@export var type: String = "placeholder"

func _ready() -> void:
	$despawn_timer.start(5)
	
	
func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		# Collects specific pickup and adds to player
		if type == "heart":
			if body.health < 100:
				body.health += amount
		elif type == "xp":
			body.xp += amount
		elif type == "coin":
			body.coins += amount
		body.update_stats()
		self.queue_free()
			

func _on_despawn_timer_timeout() -> void:
	self.queue_free()
