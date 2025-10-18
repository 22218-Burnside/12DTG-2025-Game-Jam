extends Area2D
var damage = 0
var speed = 600
var direction = Vector2.ZERO

func _ready() -> void:
	$die_time.start(2)
	
	
func _physics_process(delta: float) -> void:
	self.position += direction * speed * delta
	
	
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		if area.vulnerable:
			area.health -= damage * 2
		else:
			area.health -= damage
		if area.health <= 0:
			area.die()


func _on_die_time_timeout() -> void:
	self.queue_free()
