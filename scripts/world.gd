extends Node2D
var enemy = preload("res://prefabs/enemy.tscn")
var tank = preload("res://prefabs/tank.tscn")
var heart = preload("res://prefabs/heart.tscn")
var max_wave = 100
var max_wave_capacity = 10
var wave_points = 50
var capacity = 0
var enemy_difficulty = 1.0
var enemies = {
	"enemy" : [preload("res://prefabs/enemy.tscn"),1],
	"tank" : [preload("res://prefabs/tank.tscn"),10],
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$level_ui.hide()
	$menu.show()
	$menu/menu_camera.make_current()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$level_ui/Label2.text = "Enemies left: " + str(capacity)
	$level_ui/Label3.text = "Enemy points: " + str(int(wave_points))
	$level_ui/Label4.text = "Wave: " + str(max_wave_capacity-9)
	if capacity < max_wave_capacity and wave_points > 0:
		spawn_enemy()
	if capacity <= 0 and wave_points <= 0:
		pause_game()

func pause_game():
	get_tree().paused = true
	$upgrade_selection.show()
	
	
func next_level():
	get_tree().paused = false
	$upgrade_selection.hide()
	max_wave *= randf_range(1.1,1.5)
	wave_points = round(max_wave)
	max_wave_capacity += 1
	capacity = 0
	
	
func spawn_enemy() -> void:
	# Don't spawn if at capacity
	if capacity >= max_wave_capacity:
		return
		
	var spawned_enemy
	var enemy_keys = enemies.keys()
	
	# Find all enemies that can be spawned with current wave_points
	var valid_enemies = []
	for key in enemy_keys:
		if enemies[key][1] <= wave_points:
			valid_enemies.append(key)
	
	# Only spawn if there's at least one valid enemy
	if valid_enemies.size() > 0:
		var random_enemy = valid_enemies[randi_range(0, valid_enemies.size() - 1)]
		
		wave_points -= enemies[random_enemy][1]
		spawned_enemy = enemies[random_enemy][0].instantiate()
		capacity += 1
		add_child(spawned_enemy)
		
		# Spawn at least 350 pixels away from player
		spawned_enemy.position = Vector2(
			randi_range($player.position.x - 1000, $player.position.x + 1000), 
			randi_range($player.position.y - 1000, $player.position.y + 1000)
		)
		
		while spawned_enemy.position.distance_to($player.position) < 500:
			spawned_enemy.position = Vector2(
				randi_range($player.position.x - 1000, $player.position.x + 1000), 
				randi_range($player.position.y - 1000, $player.position.y + 1000)
			)


func player_hit(damage):
	if $player.can_hit:
		$player/Camera2D.shake(7.0, 0.5)
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
	capacity -= 1  # Decrease capacity when enemy dies
	$player.score += score
	var drop_chance = randi_range(1, 100)
	if drop_chance >= 85:
		var spawned_heart = heart.instantiate()
		call_deferred("add_child", spawned_heart)
		spawned_heart.position = death_position
	$player.update_stats()

func _on_play_pressed() -> void:
	for i in get_tree().get_nodes_in_group("enemy"):
		i.queue_free()
	$menu.hide()
	$level_ui.show()
	$player.setup()
	$player/Camera2D.make_current()
	wave_points = 10  # Reset wave points
	max_wave_capacity = 10
	max_wave = 100
	capacity = 0  # Reset capacity
