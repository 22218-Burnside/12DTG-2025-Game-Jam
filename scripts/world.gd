extends Node2D

# Preloaded scenes
var enemy = preload("res://prefabs/enemy.tscn")
var tank = preload("res://prefabs/tank.tscn")
var heart = preload("res://prefabs/heart.tscn")

# Wave configuration constants
const INITIAL_WAVE_POINTS = 100
const INITIAL_MAX_WAVE = 20
const INITIAL_MAX_WAVE_CAPACITY = 10
const WAVE_MULTIPLIER_MIN = 1.1
const WAVE_MULTIPLIER_MAX = 1.2
const WAVE_DISPLAY_OFFSET = 9

# Spawn configuration constants
const MIN_SPAWN_DISTANCE = 200
const SPAWN_RANGE = 500

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
@onready var player = $player
@onready var player_camera = $player/Camera2D
@onready var immunity_timer = $player/immunity_timer
@onready var spawn_timer = $spawn_timer
@onready var immunity_indicator = $level_ui/immunity

# UI Label references
@onready var enemies_left_label = $level_ui/Control/VBoxContainer/enemies_left
@onready var enemy_points_label = $level_ui/Control/VBoxContainer2/wave_points
@onready var wave_label = $level_ui/Control/VBoxContainer/wave
@onready var level_label = $level_ui/Control/VBoxContainer/level

# Upgrade labels
@onready var upgrade_1_label = $upgrade_selection/Label
@onready var upgrade_2_label = $upgrade_selection/Label2
@onready var upgrade_3_label = $upgrade_selection/Label3
@onready var upgrade_4_label = $upgrade_selection/Label4

@onready var element_1: Button = $upgrade_selection/Control/HBoxContainer/upgrade1
@onready var element_2: Button = $upgrade_selection/Control/HBoxContainer/upgrade2
@onready var element_3: Button = $upgrade_selection/Control/HBoxContainer/upgrade3
@onready var element_4: Button = $upgrade_selection/Control/HBoxContainer/upgrade4


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_ui.show()
	upgrade_selection.hide()
	for i in get_tree().get_nodes_in_group("enemy"):
		i.queue_free()
	player.setup()
	player_camera.make_current()
	wave_points = INITIAL_WAVE_POINTS
	max_wave_capacity = INITIAL_MAX_WAVE_CAPACITY
	max_wave = INITIAL_MAX_WAVE
	level = 1
	capacity = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	
	enemies_left_label.text = "Enemies left: " + str(capacity)
	enemy_points_label.text = "Enemy points: " + str(int(wave_points))
	if capacity < max_wave_capacity and wave_points > 0:
		spawn_enemy()
		
	Globals.exp_to_next_level = (Globals.level + 1) * 2
	if Globals.experiance >= Globals.exp_to_next_level:
		Globals.level += 1
		Globals.experiance = 0
		pause_game()
		
		

func pause_game():
	get_tree().paused = true
	update_upgrades()
	upgrade_selection.show()
	level_ui.hide()


func update_upgrades() -> void:
	if player.ELEMENTS[0]:
		element_1.upgrade_name = player.ELEMENTS[0][0].element_name
		element_1.upgrade_icon = player.ELEMENTS[0][0].element_texture

		element_1.disabled = false
	else:
		element_1.disabled = true
	
	if player.ELEMENTS[1]:
		element_2.upgrade_name = player.ELEMENTS[1][0].element_name
		element_2.upgrade_icon = player.ELEMENTS[1][0].element_texture

		element_2.disabled = false
	else:
		element_2.disabled = true

	if player.ELEMENTS[2]:
		element_3.upgrade_name = player.ELEMENTS[2][0].element_name
		element_3.upgrade_icon = player.ELEMENTS[2][0].element_texture

		element_3.disabled = false
	else:
		element_3.disabled = true

	if player.ELEMENTS[3]:
		element_4.upgrade_name = player.ELEMENTS[3][0].element_name
		element_4.upgrade_icon = player.ELEMENTS[3][0].element_texture

		element_4.disabled = false
	else:
		element_4.disabled = true
	
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
	level_label.text = "Level: " + str(level)
	wave = 1
	wave_label.text = "Wave: 1"


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
	level_ui.show()
	player.setup()
	player_camera.make_current()
	wave_points = INITIAL_WAVE_POINTS
	max_wave_capacity = INITIAL_MAX_WAVE_CAPACITY
	max_wave = INITIAL_MAX_WAVE
	capacity = 0

func element_1_upgrade() -> void:
	player.level_up_slot(1)
	#upgrade_1_label.text
	next_wave()

func element_2_upgrade() -> void:
	player.level_up_slot(2)
	#upgrade_2_label.text = "Earth\nLevel " + str(player.earth_level) + " >>> " + str(player.earth_level + 1) + "\nDamage " + str(current_damage) + " >>> " + str(next_damage)
	next_wave()

func element_3_upgrade() -> void:
	player.level_up_slot(3)
	#upgrade_3_label.text = "Water\nLevel " + str(player.water_level) + " >>> " + str(player.water_level + 1) + "\nDamage " + str(current_damage) + " >>> " + str(next_damage)
	next_wave()

func element_4_upgrade() -> void:
	player.level_up_slot(4)
	#upgrade_4_label.text = "Wind\nLevel " + str(player.wind_level) + " >>> " + str(player.wind_level + 1) + "\nDamage " + str(current_damage) + " >>> " + str(next_damage)
	next_wave()
