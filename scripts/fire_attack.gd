extends Node2D
var damage = 0
var speed = 600
var direction = Vector2.ZERO

func _ready() -> void:
	$die_time.start(5)
	damage = 50 * (0.8 + Globals.fire_level/5.0)
	if Globals.fire_level >= 1:
		$Area2D/CollisionShape2D.disabled = false
		$Area2D.show()
	if Globals.fire_level >= 2:
		$Area2D2/CollisionShape2D.disabled = false
		$Area2D2.show()
	if Globals.fire_level >= 3:
		$Area2D3/CollisionShape2D.disabled = false
		$Area2D3.show()
	if Globals.fire_level >= 4:
		$Area2D4/CollisionShape2D.disabled = false
		$Area2D4.show()

func _physics_process(delta: float) -> void:
	self.rotation += delta*10
	
	
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
