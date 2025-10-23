extends Node
class_name ElementAbilities

var player : Player

@onready var water = preload("res://prefabs/attacks/water_attack.tscn")
@onready var fire = preload("res://prefabs/attacks/fire_attack/fire_attack.tscn")
@onready var wind = preload("res://prefabs/attacks/wind_attack.tscn")
@onready var earth = preload("res://prefabs/attacks/earth_attack.tscn")

func water_attack(level : int):
	var closest_enemy_distance = INF
	var closest_enemy_position = Vector2.ZERO
	var enemy_found = false
	
	for i in get_tree().get_nodes_in_group("enemy"):
		var distance = i.position.distance_squared_to(player.position)
		if distance < closest_enemy_distance:
			closest_enemy_distance = distance
			closest_enemy_position = i.position
			enemy_found = true
	
	# Only fire if an enemy was actually found
	if enemy_found:
		var spawned_attack = water.instantiate()
		spawned_attack.level = level
		
		spawned_attack.position = player.position
		# Calculate direction FROM player TO enemy
		spawned_attack.look_at(closest_enemy_position)
		spawned_attack.direction = (closest_enemy_position - player.position).normalized()
		if closest_enemy_position.x < player.position.x:
			spawned_attack.find_child("Icon").flip_v = true
		player.get_parent().add_child(spawned_attack)

func fire_attack(level : int):
	var spawned_attack = fire.instantiate()
	spawned_attack.level = level
	player.add_child(spawned_attack)

func wind_attack(level : int):
	var spawned_attack = wind.instantiate()
	spawned_attack.level = level
	player.add_child(spawned_attack)


func earth_attack(level : int):
	var spawned_attack = earth.instantiate()
	spawned_attack.level = level
	spawned_attack.position = Vector2(randf_range(-50.0, 50.0), randf_range(-50.0, 50.0)) + player.position
	player.get_parent().add_child(spawned_attack)
