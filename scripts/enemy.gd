extends Area2D

const SPEED : int = 150
var health = 100
var damage = 10
var score = 10
var xp = 10
var coins = 5
var player : Node2D


signal death
signal enemy_hit_player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_node("player")
	enemy_hit_player.connect($".."._on_enemy_enemy_hit_player)
	death.connect($".."._on_enemy_killed)


func _physics_process(delta: float) -> void:
	if self.position.distance_to(player.position) > 128:
		position += SPEED * position.direction_to(player.position) * delta


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		enemy_hit_player.emit(damage)


func die():
	death.emit(score, xp, coins, self.position)
	self.queue_free()
