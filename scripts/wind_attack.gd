extends Area2D

var damage = 0

func _ready() -> void:
	$attack_timer.start(0.05)


func _on_attack_timer_timeout() -> void:
	for i in get_overlapping_areas():
		if i.is_in_group("enemy"):
			if i.vulnerable:
				i.health -= damage * 2
			else:
				i.health -= damage
			if i.health <= 0:
				i.die()
	self.queue_free()
