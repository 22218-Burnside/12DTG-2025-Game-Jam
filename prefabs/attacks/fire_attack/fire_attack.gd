extends Node2D
var damage = 0
var speed = 600
var level : int
var direction = Vector2.ZERO

const FIREBALL_OFFSET : int = 100
const FIREBALL_COUNT : int = 3
const FIREBALL = preload("uid://cvx2na3sdqih6")

func _ready() -> void:
	for i in range(FIREBALL_COUNT + level - 1):
		var fireball = FIREBALL.instantiate()
		fireball.position = Vector2(cos(2 * PI * i / (1.0 * (FIREBALL_COUNT + level - 1))),
		sin(2 * PI * i / (1.0 * (FIREBALL_COUNT + level - 1)))) * FIREBALL_OFFSET
		add_child(fireball)
	
	$die_time.start(5)
	
	
func _physics_process(delta: float) -> void:
	self.rotation += delta*10


func _on_die_time_timeout() -> void:
	self.queue_free()
