extends Area2D

var damage : int = 0
var level : int = 0

func _ready() -> void:
	damage = 50 + level * 10
	$attack_timer.start(0.05)


func _on_attack_timer_timeout() -> void:
	for i in get_overlapping_areas():
		if i.is_in_group("enemy"):
			i.health -= damage
			if i.health <= 0:
				i.die()
	self.queue_free()
