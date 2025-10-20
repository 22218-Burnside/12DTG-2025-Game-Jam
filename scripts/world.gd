extends Node2D

# Preloaded scenes
var enemy = preload("res://prefabs/enemy.tscn")
var tank = preload("res://prefabs/tank.tscn")
var heart = preload("res://prefabs/heart.tscn")

# Wave configuration constants
const INITIAL_WAVE_POINTS = 10
const INITIAL_MAX_WAVE = 20
const INITIAL_MAX_WAVE_CAPACITY = 10
const WAVE_MULTIPLIER_MIN = 1.1
const WAVE_MULTIPLIER_MAX = 1.2
const WAVE_DISPLAY_OFFSET = 9

# Spawn configuration constants
const MIN_SPAWN_DISTANCE = 500
const SPAWN_RANGE = 1000

# Drop configuration constants
const HEART_DROP_CHANCE_MIN = 85
const HEART_DROP_CHANCE_MAX = 100

# Camera shake constants
const CAMERA_SHAKE_STRENGTH = 7.0
const CAMERA_SHAKE_DURATION = 0.5

# Upgrade damage calculation constants
const BASE_DAMAGE = 50
const DAMAGE_BASE_MULTIPLIER = 0.8
const DAMAGE_LEVEL_DIVISOR = 5.0

# Enemy costs
const ENEMY_COST = 1
const TANK_COST = 10

# Game state variables
var max_wave = INITIAL_MAX_WAVE
var max_wave_capacity = INITIAL_MAX_WAVE_CAPACITY
var wave_points = INITIAL_WAVE_POINTS
var capacity = 0
var enemy_difficulty = 1.0
var wave = 1
var max_wave_amount = 3
var level = 1

var enemies = {
	"enemy" : [preload("res://prefabs/enemy.tscn"), ENEMY_COST],
	"tank" : [preload("res://prefabs/tank.tscn"), TANK_COST],
}

# Node references
@onready var level_ui = $level_ui
@onready var upgrade_selection = $upgrade_selection
@onready var menu = $menu
@onready var menu_camera = $menu/menu_camera
@onready var player = $player
@onready var player_camera = $player/Camera2D
@onready var immunity_timer = $player/immunity_timer
@onready var spawn_timer = $spawn_timer
@onready var immunity_indicator = $level_ui/immunity

# UI Label references
@onready var enemies_left_label = $level_ui/Control/VBoxContainer/Label2
@onready var enemy_points_label = $level_ui/Control/VBoxContainer/Label3
@onready var wave_label =$level_ui/Control/VBoxContainer/Label4
@onready var menu_label = $menu/Label

# Upgrade labels
@onready var fire_upgrade_label = $upgrade_selection/Label
@onready var earth_upgrade_label = $upgrade_selection/Label2
@onready var water_upgrade_label = $upgrade_selection/Label3
@onready var wind_upgrade_label = $upgrade_selection/Label4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.setup()
	level_ui.hide()
	upgrade_selection.hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	enemies_left_label.text = "Enemies left: " + str(capacity)
	enemy_points_label.text = "Enemy points: " + str(int(wave_points))
	if capacity < max_wave_capacity and wave_points > 0:
		spawn_enemy()
	if capacity <= 0 and wave_points <= 0:
		pause_game()

func pause_game():
	get_tree().paused = true
	
	upgrade_selection.show()
	level_ui.hide()


func update_upgrades() -> void:
	pass
	
func next_wave():
	get_tree().paused = false
	upgrade_selection.hide()
	level_ui.show()
	max_wave *= randf_range(WAVE_MULTIPLIER_MIN, WAVE_MULTIPLIER_MAX)
	wave_points = round(max_wave)
	max_wave_capacity += 1
	wave += 1
	if wave > max_wave_amount:
		next_level()
	else:
		wave_label.text = "Wave: " + str(wave)
	capacity = 0


func next_level():
	level += 1
	#level_label.text = "Level: " + str(level)
	wave = 1
	wave_label.text = "Wave: 1"


func calculate_damage(ability_level: int) -> int:
	return int(BASE_DAMAGE * (DAMAGE_BASE_MULTIPLIER + ability_level / DAMAGE_LEVEL_DIVISOR))
	
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
		
		# Spawn at least MIN_SPAWN_DISTANCE pixels away from player
		spawned_enemy.position = Vector2(
			randi_range(player.position.x - SPAWN_RANGE, player.position.x + SPAWN_RANGE), 
			randi_range(player.position.y - SPAWN_RANGE, player.position.y + SPAWN_RANGE)
		)
		
		while spawned_enemy.position.distance_to(player.position) < MIN_SPAWN_DISTANCE:
			spawned_enemy.position = Vector2(
				randi_range(player.position.x - SPAWN_RANGE, player.position.x + SPAWN_RANGE), 
				randi_range(player.position.y - SPAWN_RANGE, player.position.y + SPAWN_RANGE)
			)

func player_hit(damage):
	if player.can_hit:
		player_camera.shake(CAMERA_SHAKE_STRENGTH, CAMERA_SHAKE_DURATION)
		player.health -= damage
		player.can_hit = false
		immunity_indicator.show()
		immunity_timer.start()
	player.update_stats()
	if player.health <= 0:
		player_die()

func player_die():
	get_tree().change_scene_to_file("res://title_screen/control.tscn")

func _on_enemy_enemy_hit_player(damage) -> void:
	player_hit(damage)

func _on_enemy_killed(score, death_position):
	capacity -= 1  # Decrease capacity when enemy dies
	player.score += score
	var drop_chance = randi_range(1, HEART_DROP_CHANCE_MAX)
	if drop_chance >= HEART_DROP_CHANCE_MIN:
		var spawned_heart = heart.instantiate()
		call_deferred("add_child", spawned_heart)
		spawned_heart.position = death_position
	player.update_stats()

func _on_play_pressed() -> void:
	for i in get_tree().get_nodes_in_group("enemy"):
		i.queue_free()
	menu.hide()
	level_ui.show()
	player.setup()
	player_camera.make_current()
	wave_points = INITIAL_WAVE_POINTS
	max_wave_capacity = INITIAL_MAX_WAVE_CAPACITY
	max_wave = INITIAL_MAX_WAVE
	capacity = 0

func _on_fire_pressed() -> void:
	player.fire_level += 1
	var current_damage = calculate_damage(player.fire_level - 1)
	var next_damage = calculate_damage(player.fire_level)
	fire_upgrade_label.text = "Fire\nLevel " + str(player.fire_level) + " >>> " + str(player.fire_level + 1) + "\nDamage " + str(current_damage) + " >>> " + str(next_damage)
	next_wave()

func _on_earth_pressed() -> void:
	player.earth_level += 1
	var current_damage = calculate_damage(player.earth_level - 1)
	var next_damage = calculate_damage(player.earth_level)
	earth_upgrade_label.text = "Earth\nLevel " + str(player.earth_level) + " >>> " + str(player.earth_level + 1) + "\nDamage " + str(current_damage) + " >>> " + str(next_damage)
	next_wave()

func _on_water_pressed() -> void:
	player.water_level += 1
	var current_damage = calculate_damage(player.water_level - 1)
	var next_damage = calculate_damage(player.water_level)
	water_upgrade_label.text = "Water\nLevel " + str(player.water_level) + " >>> " + str(player.water_level + 1) + "\nDamage " + str(current_damage) + " >>> " + str(next_damage)
	next_wave()

func _on_wind_pressed() -> void:
	player.wind_level += 1
	var current_damage = calculate_damage(player.wind_level - 1)
	var next_damage = calculate_damage(player.wind_level)
	wind_upgrade_label.text = "Wind\nLevel " + str(player.wind_level) + " >>> " + str(player.wind_level + 1) + "\nDamage " + str(current_damage) + " >>> " + str(next_damage)
	next_wave()
