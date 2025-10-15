extends Area2D

const SPEED : int = 50
var health = 200
var damage = 10
var points = 10
var player : Node2D
var can_attack = true

signal death
signal enemy_hit_player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_node("player")
	enemy_hit_player.connect($".."._on_enemy_enemy_hit_player)
	death.connect($".."._on_enemy_killed)


func _physics_process(delta: float) -> void:
	if can_attack:
		for i in get_overlapping_bodies():
			if i.name == "player":
				can_attack = false
				enemy_hit_player.emit(damage)
				$attack_timer.start(1.5)
	if self.position.distance_to(player.position) > 128:
		position += SPEED * position.direction_to(player.position) * delta

func die():
	death.emit(points,self.position)
	self.queue_free()


func _on_attack_timer_timeout() -> void:
	can_attack = true
