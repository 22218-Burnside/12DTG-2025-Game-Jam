extends Node2D

var enemy = preload("res://prefabs/enemy.tscn")
var heart = preload("res://prefabs/heart.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$level_ui.hide()
	$menu.show()
	$menu/menu_camera.make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func player_hit(damage):
	if $player.can_hit:
		$player/Camera2D.shake(5.0,0.5)
		$player.health -= damage
		$player.can_hit = false
		$level_ui/immunity.show()
		$player/immunity_timer.start()
	$player.update_stats()
	if $player.health <= 0:
		player_die()

func player_die():
	$player.controlling = false
	$menu/Label.show()
	$menu.show()
	$level_ui.hide()
	$spawn_timer.stop()
	$menu/menu_camera.make_current()
	
	
func _on_enemy_enemy_hit_player(damage) -> void:
	player_hit(damage)

func _on_enemy_killed(score, death_position):
	$player.score += score
	var drop_chance = randi_range(1,100)
	if drop_chance >= 85:
		var spawned_heart = heart.instantiate()
		call_deferred("add_child",spawned_heart)
		spawned_heart.position = death_position
	$player.update_stats()
	

func _on_play_pressed() -> void:
	for i in get_tree().get_nodes_in_group("enemy"):
		i.queue_free()
	$menu.hide()
	$level_ui.show()
	$player.setup()
	$player/Camera2D.make_current()
	spawn_enemy()


func spawn_enemy() -> void:
	$spawn_timer.start(1)
	var spawned_enemy = enemy.instantiate()
	add_child(spawned_enemy)
	spawned_enemy.position = Vector2(randi_range($player.position.x + 500,$player.position.x - 500),randi_range($player.position.y + 500,$player.position.y - 500))
	while abs(spawned_enemy.position).distance_to(abs($player.position)) < 350:
		spawned_enemy.position = Vector2(randi_range($player.position.x + 500,$player.position.x - 500),randi_range($player.position.y + 500,$player.position.y - 500))
