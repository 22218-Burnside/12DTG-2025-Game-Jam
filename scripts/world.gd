extends Node2D

var enemy = preload("res://prefabs/enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$level_ui.hide()
	$menu.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func player_hit(damage):
	$player.health -= damage
	$level_ui/ProgressBar.value = $player.health
	if $player.health <= 0:
		$player.controlling = false
		$menu/Label.show()
		$menu.show()
		$level_ui.hide()
		$spawn_timer.stop()


func _on_enemy_enemy_hit_player(damage) -> void:
	player_hit(damage)

func _on_enemy_killed(score):
	$player.score += score
	$level_ui/Label.text = "Score: " + str($player.score)
	

func _on_play_pressed() -> void:
	for i in get_tree().get_nodes_in_group("enemy"):
		i.queue_free()
	$menu.hide()
	$level_ui.show()
	$player.setup()
	spawn_enemy()


func spawn_enemy() -> void:
	$spawn_timer.start(1)
	var spawned_enemy = enemy.instantiate()
	add_child(spawned_enemy)
	spawned_enemy.position = Vector2(randi_range($player.position.x + 500,$player.position.x - 500),randi_range($player.position.y + 500,$player.position.y - 500))
	while abs(spawned_enemy.position).distance_to(abs($player.position)) < 350:
		spawned_enemy.position = Vector2(randi_range($player.position.x + 500,$player.position.x - 500),randi_range($player.position.y + 500,$player.position.y - 500))
