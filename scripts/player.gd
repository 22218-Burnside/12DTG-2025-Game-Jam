extends CharacterBody2D

const WATER_ELEMENT = preload("uid://bm0nfhtxr8et8")
const FIRE_ELEMENT = preload("uid://dirvbjxkn2pam")
const WIND_ELEMENT = preload("uid://duoekhjeg3c58")
const EARTH_ELEMENT = preload("uid://cikihy5ag5kj7")

var ELEMENTS : Array = [
	null,
	null,
	null,
	null
]

const SPEED = 150.0
var health = 100
var score = 0
var attack_time = 1.5
var fire_attack_time = 8
var wind_attack_time = 0.8
var earth_attack_time = 3
var controlling = false
var can_hit = true
var water_level = 1 :
	set(value):
		water_level = value
		hotbar.element_slots[0].element_level += 1
var fire_level = 0 : 
	set(value):
		fire_level = value
		hotbar.element_slots[1].element_level += 1
var earth_level = 0 :
	set(value):
		earth_level = value
		hotbar.element_slots[3].element_level += 1
var wind_level = 0 :
	set(value):
		wind_level = value
		hotbar.element_slots[2].element_level += 1
var wind_damage = 50
var fire_damage = 50
var water_damage = 50
var earth_damage = 0

@onready var water = preload("res://prefabs/attacks/water_attack.tscn")
@onready var fire = preload("res://prefabs/attacks/fire_attack/fire_attack.tscn")
@onready var wind = preload("res://prefabs/attacks/wind_attack.tscn")
@onready var earth = preload("res://prefabs/attacks/earth_attack.tscn")

@onready var hotbar = $hotbar
@onready var slot_1_timer = $slot1timer
@onready var slot_2_timer = $slot2timer
@onready var slot_3_timer = $slot3timer
@onready var slot_4_timer = $slot4timer



func setup():
	controlling = true
	health = 100
	score = 0
	
	#$".."/level_ui/Control/Label.text = "Score: 0"
	$"../level_ui/Control/VBoxContainer/ProgressBar".value = health
	
	change_slot(1, WATER_ELEMENT)
	change_slot(2, FIRE_ELEMENT)
	change_slot(3, WIND_ELEMENT)
	change_slot(4, EARTH_ELEMENT)


func _physics_process(_delta: float) -> void:
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

		move_and_slide()


func update_stats():
	$"../level_ui/Control/VBoxContainer/Label".text = "Score: " + str(score)
	$"../level_ui/Control/VBoxContainer/ProgressBar".value = health


func change_slot(slot_number : int, element : Element):
	ELEMENTS[slot_number - 1] = [element, Callable(self, element.function), 1]
	var slot_timer : Timer = get_node("slot" + str(slot_number) + "timer")
	slot_timer.wait_time = element.timer
	slot_timer.start()
	hotbar.element_slots[slot_number - 1].element = element
	hotbar.element_slots[slot_number - 1].element_level = 1


func level_up_slot(slot_number : int) -> void:
	ELEMENTS[slot_number - 1][2] += 1


func slot_timeout(slot_number : int) -> bool:
	if ELEMENTS[slot_number - 1]:
		ELEMENTS[slot_number - 1][1].call(ELEMENTS[slot_number - 1][0].damage, 
		ELEMENTS[slot_number - 1][2])
		return true
	else:
		return false

func slot1timeout() -> void:
	if slot_timeout(1):
		slot_1_timer.start()


func slot2timeout() -> void:
	if slot_timeout(2):
		slot_2_timer.start()


func slot3timeout() -> void:
	if slot_timeout(3):
		slot_3_timer.start()


func slot4timeout() -> void:
	if slot_timeout(4):
		slot_4_timer.start()

func water_attack(damage : int, level : int):
	if controlling:
		var closest_enemy_distance = INF
		var closest_enemy_position = Vector2.ZERO
		var enemy_found = false
		
		for i in get_tree().get_nodes_in_group("enemy"):
			var distance = i.position.distance_squared_to(self.position)
			if distance < closest_enemy_distance:
				closest_enemy_distance = distance
				closest_enemy_position = i.position
				enemy_found = true
		
		# Only fire if an enemy was actually found
		if enemy_found:
			var spawned_attack = water.instantiate()
			spawned_attack.damage = damage * (0.8 + level/5.0)
			
			spawned_attack.position = self.position
			# Calculate direction FROM player TO enemy
			spawned_attack.look_at(closest_enemy_position)
			spawned_attack.direction = (closest_enemy_position - self.position).normalized()
			if closest_enemy_position.x < self.position.x:
				spawned_attack.find_child("Icon").flip_v = true
			get_parent().add_child(spawned_attack)

func fire_attack(damage : int, level : int):
	if controlling:
		var spawned_attack = fire.instantiate()
		spawned_attack.damage = damage * (0.8 + level/5.0)
		spawned_attack.level = level
		add_child(spawned_attack)

func wind_attack(damage : int, level : int):
	if controlling:
		var spawned_attack = wind.instantiate()
		spawned_attack.damage = damage * (0.8 + level/5.0)
		add_child(spawned_attack)


func earth_attack(_damage : int, _level : int):
	if controlling:
		var spawned_attack = earth.instantiate()
		spawned_attack.position = Vector2(randf_range(position.x-500.0,position.x + 500.0), randf_range(position.y-500.0,position.y + 500.0))
		get_parent().add_child(spawned_attack)
		


func _on_immunity_timer_timeout() -> void:
	can_hit = true
	$".."/level_ui/immunity.hide()
