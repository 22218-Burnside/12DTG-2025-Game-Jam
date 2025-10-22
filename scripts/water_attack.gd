extends Area2D
var damage : int
var speed = 200
var direction = Vector2.ZERO
var level : int
const DAMAGE_INDICATOR = preload("uid://drucr8c11yv4b")

func _ready() -> void:
	$die_time.start(2)
	damage = 50 + (level - 1) * 10
	
	
func _physics_process(delta: float) -> void:
	self.position += direction * speed * delta
	
	
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		area.health -= damage
		var ind = DAMAGE_INDICATOR.instantiate()
		get_parent().add_child(ind)
		ind.position = global_position
		if area.health <= 0:
			area.die()


func _on_die_time_timeout() -> void:
	self.queue_free()
