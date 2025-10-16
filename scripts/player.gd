extends CharacterBody2D


const SPEED = 300.0
var health = 100
var score = 0
var attack_time = 1.5
var fire_attack_time = 8
var wind_attack_time = 0.8
var controlling = false
var can_hit = true
var water_level = 1
var fire_level = 0
var earth_level = 0
var wind_level = 0
var wind_damage = 50
var fire_damage = 50
var water_damage = 50
var earth_damage = 0

@onready var water = preload("res://prefabs/attack.tscn")
@onready var fire = preload("res://prefabs/fire_attack.tscn")
@onready var wind = preload("res://prefabs/wind_attack.tscn")
func setup():
	controlling = true
	health = 100
	score = 0
	$".."/level_ui/Label.text = "Score: 0"
	$"../level_ui/ProgressBar".value = health
	water_attack()

func _physics_process(_delta: float) -> void:
	if controlling:
		var direction_x := Input.get_axis("left", "right")
		if direction_x:
			velocity.x = direction_x * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		var direction_y := Input.get_axis("up", "down")
		if direction_y:
			velocity.y = direction_y * SPEED
		else:
			velocity.y = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.x, 0, SPEED)
	move_and_slide()


func update_stats():
	$".."/level_ui/Label.text = "Score: " + str(score)
	$"../level_ui/ProgressBar".value = health


func water_attack():
	if controlling:
		var closest_enemy_distance = INF
		var closest_enemy_position = Vector2.ZERO
		var enemy_found = false
		
		for i in get_tree().get_nodes_in_group("enemy"):
			var distance = i.position.distance_to(self.position)
			if distance < closest_enemy_distance:
				closest_enemy_distance = distance
				closest_enemy_position = i.position
				enemy_found = true
		
		# Only fire if an enemy was actually found
		if enemy_found:
			$attack_timer.start(attack_time)
			var spawned_attack = water.instantiate()
			$"..".add_child(spawned_attack)
			spawned_attack.position = self.position
			# Calculate direction FROM player TO enemy
			spawned_attack.look_at(closest_enemy_position)
			spawned_attack.direction = (closest_enemy_position - self.position).normalized()

func fire_attack():
	if controlling:
		$fire_timer.start(fire_attack_time)
		var spawned_attack = fire.instantiate()
		add_child(spawned_attack)

func wind_attack():
	if controlling:
		$wind_timer.start(wind_attack_time)
		var spawned_attack = wind.instantiate()
		add_child(spawned_attack)


func _on_immunity_timer_timeout() -> void:
	can_hit = true
	$".."/level_ui/immunity.hide()
