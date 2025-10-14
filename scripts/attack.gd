extends Area2D
var damage = 250
var speed = 200
var direction = Vector2.ZERO

func _ready() -> void:
	$die_time.start(2)
	
	
func _physics_process(delta: float) -> void:
	self.position += direction * speed * delta
	
	
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		area.health -= damage
		if area.health <= 0:
			area.die()
		self.queue_free()


func _on_die_time_timeout() -> void:
	self.queue_free()
